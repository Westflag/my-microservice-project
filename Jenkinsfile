pipeline {
  agent none

  environment {
    AWS_REGION        = 'us-west-2'
    IMAGE_REPOSITORY  = 'REPLACE_WITH_ECR_REPOSITORY_URL'
    GITOPS_REPO_URL   = 'https://github.com/example/gitops-repo.git'
    GITOPS_BRANCH     = 'main'
    GITOPS_CHART_PATH = 'charts/django-app'
  }

  stages {
    stage('Checkout application source') {
      agent any
      steps {
        checkout scm
        script {
          env.COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          env.IMAGE_TAG = "${env.BUILD_NUMBER}-${env.COMMIT_SHORT}"
        }
      }
    }

    stage('Build and push image to ECR') {
      agent {
        kubernetes {
          defaultContainer 'kaniko'
          yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.23.2-debug
      command: ["/busybox/cat"]
      tty: true
      volumeMounts:
        - name: docker-config
          mountPath: /kaniko/.docker
    - name: aws
      image: amazon/aws-cli:2.17.40
      command: ["cat"]
      tty: true
      volumeMounts:
        - name: docker-config
          mountPath: /kaniko/.docker
  volumes:
    - name: docker-config
      emptyDir: {}
"""
        }
      }
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          container('aws') {
            sh '''#!/bin/sh
set -eu
REGISTRY=$(echo "$IMAGE_REPOSITORY" | cut -d/ -f1)
PASSWORD=$(aws ecr get-login-password --region "$AWS_REGION")
mkdir -p /kaniko/.docker
cat > /kaniko/.docker/config.json <<JSON
{
  "auths": {
    "https://${REGISTRY}": {
      "username": "AWS",
      "password": "${PASSWORD}"
    }
  }
}
JSON
'''
          }

          container('kaniko') {
            sh '''#!/busybox/sh
set -eu
/kaniko/executor \
  --context "${WORKSPACE}" \
  --dockerfile "${WORKSPACE}/Dockerfile" \
  --destination "${IMAGE_REPOSITORY}:${IMAGE_TAG}" \
  --destination "${IMAGE_REPOSITORY}:latest" \
  --cache=true
'''
          }
        }
      }
    }

    stage('Update GitOps values.yaml') {
      agent {
        kubernetes {
          defaultContainer 'git'
          yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: git
      image: alpine/git:2.45.2
      command: ["cat"]
      tty: true
"""
        }
      }
      steps {
        container('git') {
          withCredentials([
            usernamePassword(credentialsId: 'gitops-pat', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')
          ]) {
            sh '''#!/bin/sh
set -eu
rm -rf /tmp/gitops-repo
AUTHED_URL=$(echo "$GITOPS_REPO_URL" | sed "s#https://#https://${GIT_USERNAME}:${GIT_PASSWORD}@#")
git clone --branch "$GITOPS_BRANCH" "$AUTHED_URL" /tmp/gitops-repo
cd /tmp/gitops-repo
VALUES_FILE="$GITOPS_CHART_PATH/values.yaml"
sed -i "s#^  repository:.*#  repository: \"${IMAGE_REPOSITORY}\"#" "$VALUES_FILE"
sed -i "s#^  tag:.*#  tag: \"${IMAGE_TAG}\"#" "$VALUES_FILE"
git config user.email "jenkins@local"
git config user.name "Jenkins"
git add "$VALUES_FILE"
git commit -m "ci: update django image tag to ${IMAGE_TAG}" || echo "No changes to commit"
git push origin "$GITOPS_BRANCH"
'''
          }
        }
      }
    }
  }

  post {
    success {
      echo "Image pushed to ${IMAGE_REPOSITORY}:${IMAGE_TAG} and GitOps repository updated."
    }
    failure {
      echo 'Pipeline failed. Check Kaniko, ECR credentials, and GitOps credentials.'
    }
  }
}
