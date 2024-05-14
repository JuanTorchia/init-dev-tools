#!/usr/bin/env node

const inquirer = require('inquirer');
const { exec } = require('child_process');
const path = require('path');

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

inquirer.prompt(questions).then(answers => {
  answers.scripts.forEach(scriptName => {
    const scriptPath = scripts[scriptName];
    console.log(`Executing ${scriptName}...`);
    exec(`bash ${scriptPath}`, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error executing ${scriptName}: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`Error output from ${scriptName}: ${stderr}`);
        return;
      }
      console.log(`Output from ${scriptName}: ${stdout}`);
    });
  });
});
