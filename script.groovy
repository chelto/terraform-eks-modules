#!/usr/bin/env groovy


def terraform_init() {
    // sh 'terraform init'
    sh './terraformw init'
    sh './terraformw version -no-color'
    
    echo 'terraform init'
}



def terraform_workspace() {
    sh './terraformw workspace list -no-color'
    // sh './terraformw workspace select ${BRANCH_NAME} -no-color'
}

def terraform_validate() {
    sh './terraformw fmt -no-color'
    sh './terraformw validate -no-color'
}

def terraform_plan() {
    sh './terraformw plan -no-color'
}

def terraform_deploy() {
    sh './terraformw apply -auto-approve -no-color'
}



def deploymain() 
    { 
        if (BRANCH_NAME == 'dev')
        {echo 'this is dev'
            terraform_deploy()
        }
        if(BRANCH_NAME == 'test')
        {
        echo 'this is test'
            terraform_deploy()
        }
        if(BRANCH_NAME == 'main')
        {
        echo 'Deploying to prod'
            terraform_deploy()
        }
        else
        {
            echo 'this is another branch'
        }
    }

def deployment_gate()
    {
        timeout(time: 10, unit: 'MINUTES') {
         input(id: "Deploy Gate", message: "Deploy ${BRANCH_NAME}?", ok: 'Deploy')
         }
    }

def destroy() 
    { 
        sh './terraformw destroy -auto-approve -no-color'
        
    }

return this