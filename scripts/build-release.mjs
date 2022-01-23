const OS_TARGETS = {
  'Windows': 'windows',
  'Linux': 'linux',
  'macOS': 'macos',
}

const OS_GODOT_COMMANDS = {
  'Windows': '.\\bin\\Godot*.exe',
  'Linux': './bin/Godot_v\*_linux_headless.64',
  'macOS': './bin/Godot.app/Contents/MacOS/Godot',
}

const os = process.env.RUNNER_OS || 'macOS'

const version = process.argv[3] || 'SNAPSHOT'
const target = process.argv[4] || OS_TARGETS[os] || 'macos';


console.log(`Build for ${target} on ${os}`);
// Get godot binary name and execute build command
const godotCommand = await globby(OS_GODOT_COMMANDS[os]);
await $`${godotCommand} --no-window --export ${target}`

await $`ls -lah build`

const releaseFiles = await globby('./build/*');
await $`7z a -sdel release/gameoff-2021-${target}.zip ${releaseFiles}`
