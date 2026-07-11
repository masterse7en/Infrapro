pipeline {
    agent any

    environment {
        TF_DIR = 'step2-ansible-userdata'
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Terraform action to run'
        )
        string(
            name: 'AWS_REGION',
            defaultValue: 'ap-south-2',
            description: 'AWS region'
        )
        choice(
            name: 'INSTANCE_TYPE',
            choices: ['t3.micro', 't3.small', 't3.medium'],
            description: 'EC2 instance type'
        )
        string(
            name: 'MANAGED_NODE_COUNT',
            defaultValue: '2',
            description: 'Number of Ansible managed nodes'
        )
        string(
            name: 'PROJECT_NAME',
            defaultValue: 'infrapro',
            description: 'Name prefix for resources'
        )
    }

    stages {
        stage('Show parameters') {
            steps {
                echo "Action:        ${params.ACTION}"
                echo "Region:        ${params.AWS_REGION}"
                echo "Instance type: ${params.INSTANCE_TYPE}"
                echo "Managed nodes: ${params.MANAGED_NODE_COUNT}"
                echo "Project name:  ${params.PROJECT_NAME}"
            }
        }

        stage('Verify AWS auth') {
            steps {
                sh 'aws sts get-caller-identity'
            }
        }

        stage('Terraform init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform plan') {
            when {
                anyOf {
                    expression { params.ACTION == 'plan' }
                    expression { params.ACTION == 'apply' }
                }
            }
            steps {
                dir("${TF_DIR}") {
                    sh """
                        terraform plan \\
                          -var='region=${params.AWS_REGION}' \\
                          -var='instance_type=${params.INSTANCE_TYPE}' \\
                          -var='managed_node_count=${params.MANAGED_NODE_COUNT}' \\
                          -var='project_name=${params.PROJECT_NAME}' \\
                          -out=tfplan
                    """
                }
            }
        }

        stage('Approval') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                input message: 'Apply this plan?', ok: 'Yes, apply'
            }
        }

        stage('Terraform apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Terraform destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir("${TF_DIR}") {
                    sh """
                        terraform destroy -auto-approve \\
                          -var='region=${params.AWS_REGION}' \\
                          -var='instance_type=${params.INSTANCE_TYPE}' \\
                          -var='managed_node_count=${params.MANAGED_NODE_COUNT}' \\
                          -var='project_name=${params.PROJECT_NAME}'
                    """
                }
            }
        }

        stage('Show outputs') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform output'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully."
        }
        failure {
            echo "Pipeline failed. Check the logs above."
        }
    }
}
