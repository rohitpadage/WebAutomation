
pipeline{

    agent any

    environment{
        Results_Dir= "Results"
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

            emailext(
            from: 'rohitpadage09@gmail.com',
            to: 'rohitpadage@gmail.com',
            subject: "Build ${currentBuild.currentResult} : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
                Job    : ${env.JOB_NAME}
                Build  : #${env.BUILD_NUMBER}
                Status : ${currentBuild.currentResult}
                URL    : ${env.BUILD_URL}
            """
        )

        }
    }


}