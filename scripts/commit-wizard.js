import inquirer from 'inquirer';
import chalk from 'chalk';
import { execSync } from 'child_process';

function pause(milliseconds) {
    return new Promise(resolve => setTimeout(resolve, milliseconds));
}

async function checkAndFixPermissions() {
    console.log(chalk.blue('Checking for executable permissions in scripts and bin directories...'));
    const directories = ['scripts', 'bin'];
    const fs = await import('fs');

    directories.forEach(dir => {
        fs.readdirSync(dir).forEach(file => {
            const filePath = `${dir}/${file}`;
            try {
                fs.accessSync(filePath, fs.constants.X_OK);
                console.log(chalk.green(`Executable permission is set for ${filePath}`));
            } catch (err) {
                fs.chmodSync(filePath, '755');
                console.log(chalk.yellow(`Set executable permission for ${filePath}`));
            }
        });
    });

    await pause(5000);
}

async function selectFilesToAdd() {
    console.clear();
    console.log(chalk.blue('Current Git Status:'));
    console.log(execSync('git status', { encoding: 'utf-8' }));

    const { addAll } = await inquirer.prompt({
        type: 'confirm',
        name: 'addAll',
        message: 'Do you want to add all untracked and changed files?',
        default: true
    });

    if (addAll) {
        execSync('git add .', { stdio: 'inherit' });
    } else {
        const { files } = await inquirer.prompt({
            type: 'checkbox',
            name: 'files',
            message: 'Select files to add:',
            choices: execSync('git ls-files --others --modified --exclude-standard', { encoding: 'utf-8' })
                      .split('\n')
                      .filter(line => line)
                      .map(name => ({ name })),
        });
        execSync(`git add ${files.join(' ')}`, { stdio: 'inherit' });
    }
}

async function commitWizard() {
    await checkAndFixPermissions();
    await selectFilesToAdd();

    console.clear();
    const { commitType } = await inquirer.prompt({
        type: 'list',
        name: 'commitType',
        message: 'What type of changes are you committing?',
        choices: ['Feature', 'Bugfix', 'Docs', 'Style', 'Refactor', 'Test', 'Chore']
    });

    const { commitMessage } = await inquirer.prompt({
        type: 'input',
        name: 'commitMessage',
        message: 'Write a concise commit message:',
        validate: input => input ? true : 'Commit message cannot be empty.'
    });

    try {
        execSync(`git commit -m "[${commitType}] ${commitMessage}" --no-verify`, { stdio: 'inherit' });
        console.log(chalk.green('Commit successful!'));
    } catch (error) {
        console.error(chalk.red('Error committing changes:', error));
        console.error(chalk.red('Stderr:', error.stderr.toString()));
        console.error(chalk.red('Stdout:', error.stdout.toString()));
    }
}

commitWizard().catch(error => console.error(chalk.red('Error:', error)));
