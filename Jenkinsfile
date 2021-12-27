pipeline {
    agent any // Выбираем Jenkins агента, на котором будет происходить сборка: нам нужен любой


	parameters      {
        text(name:'Fname',
        defaultValue: 'Александр')
        text(name:'Sname',
        defaultValue: 'Волохов')

        }


    triggers {
        pollSCM('H/5 * * * *') // Запускать будем автоматически по крону примерно раз в 5 минут
    }

    tools {
        maven 'maven' // Для сборки бэкенда нужен Maven
        jdk 'JDK' // И Java Developer Kit нужной версии
        nodejs 'nodejs' // А NodeJS нужен для фронта
    }

    stages {
        stage('Build & Test backend') {
            steps {
                dir("backend") { // Переходим в папку backend
                    sh 'mvn package' // Собираем мавеном бэкенд
                }
            }

            post {
                success {
                    junit 'backend/target/surefire-reports/**/*.xml' // Передадим результаты тестов в Jenkins
                }
            }
        }

        stage('Build frontend') {
            steps {
                dir("frontend") {
                    sh 'npm install' // Для фронта сначала загрузим все сторонние зависимости
                    sh 'npm run build' // Запустим сборку
                }
            }
        }
        
        stage('Save artifacts') {
            steps {
                archiveArtifacts(artifacts: 'backend/target/sausage-store-0.0.1-SNAPSHOT.jar')
                archiveArtifacts(artifacts: 'frontend/dist/frontend/*')
            }
        }
    

        stage('Send notification')  {

	environment {
                SLACK_TOKEN = credentials('bb7f927a-7c55-4e0f-9b57-9dd84caadaf8')
            }



            steps   {
            	//	sh ('curl -X POST -H "Content-type: application/json" \
		 //	-d \'{"text\":"А В собрал приложение."}\' \
		//	https://hooks.slack.com/services/TPV9DP0N4/B02PSECK8JF/$SLACK_TOKEN')  //Вот не смог вставить параметры(((


	///		sh ('curl -X POST -H "Content-type: application/json" \
	///		-d \'{"text\":"${params.Fname} ${params.Sname} собрал приложение."}\' \
	///		https://hooks.slack.com/services/TPV9DP0N4/B02PSECK8JF/$SLACK_TOKEN')   /// 


			sh """curl -X POST -H "Content-type: application/json"\
			-d \'{"text\":" ${params.Fname} ${params.Sname} собрал приложение."}\'  \
			https://hooks.slack.com/services/TPV9DP0N4/B02PSECK8JF/$SLACK_TOKEN"""

		}
        }
    }
    
}




