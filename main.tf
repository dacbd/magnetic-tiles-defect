terraform {
  required_providers { iterative = { source = "iterative/iterative" } }
}
provider "iterative" {}

resource "iterative_task" "gpu-runner" {
  cloud = "aws"
  machine = "m+t4"
  timeout = 2*60*60 # 2hrs
  region = "us-west-1"
  image = "nvidia"
  disk_size = 100
  permission_set = "arn:aws:iam::342840881361:instance-profile/tpi-vscode-example"
  storage {
    workdir = "."
    output = ""
  }
  script = <<-END
    #!/bin/bash
    # setup project requirments
    apt-get update >> /dev/null
    apt-get install python3.9 -y
    #python3.9 -m pip install --upgrade pip
    #python3.9 -m pip install pipenv

    #export PYTHONPATH=$CWD

    pipenv install --skip-lock
    pipenv run dvc pull
    pipenv run dvc repro

    git status
    which cml
  END
  
}
