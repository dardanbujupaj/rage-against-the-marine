const OS_IDENTIFIERS = {
  'Windows': 'win64.exe',
  'Linux': 'linux_headless.64',
  'macOS': 'osx.universal',
}

const TEMPLATE_PATHS = {
  'Windows': `${process.env.USERPROFILE}\\AppData\\Roaming\\Godot\\templates\\`,
  'Linux': `${process.env.HOME}/.local/share/godot/templates/`,
  'macOS': `${process.env.HOME}/Library/Application Support/Godot/templates/`,
}

const os = process.env.RUNNER_OS || 'macOS'

const osIdentifier = OS_IDENTIFIERS[os]

const versionString = process.argv[3];


if (versionString === undefined) {
  console.error('Version not defined. Call with version: `zx download-godot.mjs 3.3.4`');
}

const [version, prerelease] = versionString.split('-');

const baseUrl = `https://downloads.tuxfamily.org/godotengine/${version}/${prerelease ? prerelease + '/' : ''}Godot_v${version}-${prerelease || 'stable'}`;
const binaryUrl = `${baseUrl}_${osIdentifier}.zip`;
const templatesUrl = `${baseUrl}_export_templates.tpz`;



try {
  await $`mkdir bin`
} catch (error) {
  // bin directory was already there
}

console.log('Downloading and unpacking godot binary')
await downloadFile(binaryUrl, 'bin/godot.zip')
await $`7z x -y bin/godot.zip -obin`

console.log('Downloading and unpacking godot templates')
await downloadFile(templatesUrl, 'bin/templates.zip')
await $`7z e -y bin/templates.zip -o${TEMPLATE_PATHS[os] + version + '.' + (prerelease || 'stable')}`



// Download Godot
// Download Export templates

/**
 * Download a file to disk
 * @param {string} url to download the file from
 * @param {*} path to store the file to
 */
async function downloadFile(url, path) {
  const res = await fetch(url);
  const fileStream = fs.createWriteStream(path);

  await new Promise((resolve, reject) => {
    res.body.pipe(fileStream);
    res.body.on("error", reject);
    fileStream.on("finish", resolve);
  });
}