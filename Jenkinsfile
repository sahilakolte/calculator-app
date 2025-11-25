pipeline {
    agent any

    environment {
        IMAGE = "sahilakolte/ci-cd-assignment:latest"
        VENV = ".venv"
        PYTHON = "/usr/bin/python3"
    }

    stages {

        /* ---------------------------
           1. CLONE GITHUB REPOSITORY
        ---------------------------- */
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                  branches: [[name: '*/main']],
                  userRemoteConfigs: [[
                    url: 'https://github.com/sahilakolte/IMT2023066-Calculator-CI-CD',
                    credentialsId: 'ci-cd-assignment'
                  ]]
                ])
            }
        }

        /* ---------------------------
           2. CREATE VIRTUAL ENV
        ---------------------------- */
        stage('Create Virtual Environment') {
            steps {
                sh '$PYTHON -m venv $VENV'
                sh '$VENV/bin/pip install --upgrade pip'
            }
        }

        /* ---------------------------
           3. INSTALL DEPENDENCIES
        ---------------------------- */
        stage('Install Dependencies') {
            steps {
                sh '$VENV/bin/pip install pytest'
            }
        }

        /* ---------------------------
           4. RUN UNIT TESTS
        ---------------------------- */
        stage('Run Tests') {
            steps {
                sh '$VENV/bin/pytest -v'
            }
        }

        /* ---------------------------
           5. BUILD DOCKER IMAGE
        ---------------------------- */
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        /* ---------------------------
           6. PUSH IMAGE TO DOCKER HUB
        ---------------------------- */
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                      credentialsId: 'ci-cd-dockerhub',
                      usernameVariable: 'USER',
                      passwordVariable: 'PASS'
                )]) {
                    sh '''
                      echo $PASS | docker login -u $USER --password-stdin
                      docker push $IMAGE
                    '''
                }
            }
        }

        /* ---------------------------
           7. OPTIONAL: DEPLOY LOCALLY
        ---------------------------- */
        stage('Deploy Container') {
            steps {
                sh '''
                  docker pull $IMAGE
                  docker stop ci-cd-assignment || true
                  docker rm ci-cd-assignment || true
                  docker run -d -p 5000:5000 --name ci-cd-assignment $IMAGE
                '''
            }
        }
    }
}
