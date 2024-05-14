#!/usr/bin/env node

import inquirer from 'inquirer';
import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Obtener la ruta absoluta del directorio del script
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const scripts = {
  'Install Git': path.join(__dirname, '../bin/install_git.sh'),
  'Install Docker': path.join(__dirname, '../bin/install_docker.sh'),
  'Install SDKMAN, Java, and Maven': path.join(__dirname, '../bin/install_sdkman_and_java.sh'),
  'Create Maven Toolchain Configuration': path.join(__dirname, '../bin/create_maven_toolchain.sh'),
  'Generate SSH Keys': path.join(__dirname, '../bin/generate_ssh_key.sh'),
  'Install NVM': path.join(__dirname, '../bin/install_nvm.sh')
};

const questions = [
  {
    type: 'checkbox',
    name: 'scripts',
    message: 'Select the scripts you want to run:',
    choices: Object.keys(scripts),
  }
];

async function runScript(scriptPath) {
  return new Promise((resolve, reject) => {
    const child = spawn('bash', [scriptPath], { stdio: 'inherit' });

    child.on('error', (error) => {
      console.error(`Error executing ${scriptPath}: ${error.message}`);
      reject(error);
    });

    child.on('exit', (code) => {
      if (code !== 0) {
        console.error(`Error output from ${scriptPath}: exited with code ${code}`);
        reject(new Error(`Script exited with code ${code}`));
      } else {
        console.log(`Output from ${scriptPath}: completed successfully.`);
        resolve();
      }
    });
  });
}

inquirer.prompt(questions).then(async (answers) => {
  for (const scriptName of answers.scripts) {
    const scriptPath = scripts[scriptName];
    console.log(`Executing ${scriptName}...`);
    try {
      await runScript(scriptPath);
    } catch (error) {
      console.error(`Failed to execute ${scriptName}: ${error.message}`);
    }
  }
});
