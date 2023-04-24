def gv

pipeline {
  agent {
    node {
      label 'spot-agents'
    }
  }
  triggers {
        cron('00 21 * * *')
    }
  
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('terraform init') {
      steps {
        script{
          gv = load "script.groovy"
          gv.terraform_init()
        }
      }
    }
    stage('terraform validate') {
      steps {
        script{
          gv.terraform_validate()
        }
      }
    }
    stage('terraform destroy') {
      steps {
        script{
          gv.destroy() 
        }
      }
    }
    // stage('terraform deploy') {
    //   steps {
    //       script{
    //         // gv.deployment_gate()
    //         gv.deploymain()
    //       }
    //       }
    // }
    stage('post clean workspace') {
      steps {
        cleanWs()
      }
    }
  }
}