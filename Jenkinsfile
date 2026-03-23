
pipeline{

    agent any

    environment{
        ${Results_Dir}= "Results"
    }

    parameters{
        string( name: 'TAGS',description: 'Enter the test tag',defaultValue:'smoke')
    }

    stages{

        stage('Run Automation Tests'){
            steps{
                bat """ 
                robot --include ${params.TAGS} ^
                      --outputdir ${Results_Dir} ^
                      WebAutomate.robot
                """
            }
        }

    }

    post {
        always {
            archiveArtifacts artifacts: "${Results_Dir}/**", allowEmptyArchive: true
        }
    }


}