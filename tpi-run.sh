#!/bin/bash



export TF_LOG_PROVIDER=INFO
terraform init
terraform apply -auto-approve

until echo 'try(iterative_task.gpu-runner.status["succeeded"], 0) + try(iterative_task.gpu-runner.status["failed"], 0)' | terraform console | grep --quiet --invert-match 0; do
    sleep 60
    terraform refresh
done

terraform destroy -auto-approve
