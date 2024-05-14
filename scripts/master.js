#!/usr/bin/env node

import inquirer from 'inquirer'
import { spawn } from 'child_process'
import path from 'path'
import { fileURLToPath } from 'url'
import { dirname } from 'path'

// Obtener la ruta absoluta del directorio del script
const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

const scripts = {
  'Install Git': path.join(__dirname, '../bin/install_git.sh'),
  'Install Docker': path.join(__dirname, '../bin/install_docker.sh'),
  'Install SDKMAN, Java, and Maven': path.join(
    __dirname,
    '../bin/install_sdkman_and_java.sh',
  ),
  'Create Maven Toolchain Configuration': path.join(
    __dirname,
    '../bin/create_maven_toolchain.sh',
  ),
  'Generate SSH Keys': path.join(__dirname, '../bin/generate_ssh_key.sh'),
  'Install NVM': path.join(__dirname, '../bin/install_nvm.sh'),
}

const questions = [
  {
    type: 'checkbox',
    name: 'scripts',
    message: 'Select the scripts you want to run:',
    choices: Object.keys(scripts),
  },
]

inquirer.prompt(questions).then((answers) => {
  answers.scripts.forEach((scriptName) => {
    const scriptPath = scripts[scriptName]
    console.log(`Executing ${scriptName}...`)
    const child = spawn('bash', [scriptPath], { stdio: 'inherit' })

    child.on('error', (error) => {
      console.error(`Error executing ${scriptName}: ${error.message}`)
    })

    child.on('exit', (code) => {
      if (code !== 0) {
        console.error(
          `Error output from ${scriptName}: exited with code ${code}`,
        )
      } else {
        console.log(`Output from ${scriptName}: completed successfully.`)
      }
    })
  })
})
