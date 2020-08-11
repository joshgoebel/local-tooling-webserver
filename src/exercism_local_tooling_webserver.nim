import jester
import os
import osproc
import strformat
import json
import uuids

routes:
  post "/":
      # Uniq ID for this job
    let job_id = $(genUUID())

    # # Create dirs
    let job_dir = fmt"/tmp/jobs/{job_id}"
    let input_dir = fmt"{job_dir}/input"
    let output_dir = fmt"{job_dir}/output"
    os.createDir(input_dir)
    os.createDir(output_dir)

    # # Setup input
    let zip_file = fmt"{job_dir}/files.gzip"
    let zip_data = request.formData.getOrDefault("zipped_files").body
    writeFile(zip_file, zip_data)
    # File.write(zip_file, params[:zipped_files])
    discard execShellCmd fmt"unzip {zip_file} -d {input_dir}"
    # logger.info `ls -lah #{input_dir}`
    echo execProcess(fmt"ls -lah {input_dir}")

    # Run command
    # let exercise_name = params[:exercise]
    let exercise_name = request.formData.getOrDefault("exercise").body
    let cmd = fmt"./bin/run.sh {exercise_name} {input_dir} {output_dir}"
    # setCurrentDir("/opt/test-runner")
    let exit_status = execShellCmd(cmd)
    # exit_status = Dir.chdir("/opt/test-runner/") do
    #     system(cmd)
    # end

    # # Read and return the result
    # begin
    #     result = File.read("#{output_dir}/#{params[:results_filepath]}")
    # rescue Errno::ENOENT
    # end

    let response = %*
        {
            "exit_status": exit_status,
            "result": nil
        }

    let results_filepath = request.formData.getOrDefault("results_filepath").body
    if fileExists(fmt"{output_dir}/{results_filepath}"):
        response["result"] = % readFile(fmt"{output_dir}/{results_filepath}")

    resp response
    # json(
    #     exit_status: exit_status,
    #     result: result
    # )