# Webpage Monitoring System

![example.png]

This system is designed to monitor specific webpages and detect any changes in their content. It runs a script every hour that checks selected webpages and logs any changes detected.

## Components

1. **launch_checker_script.scpt**: An AppleScript that opens Terminal and executes the Bash script.
2. **auto_check_webpages.sh**: A Bash script that fetches webpages, computes their checksums, and compares these to previously stored checksums to detect changes.
3. **com.user.launchchecker.plist**: A launchd configuration file that schedules the AppleScript to run every minute.

## Setup

### Files

- **Launch Agent Configuration**: `~/Library/LaunchAgents/com.user.launchchecker.plist`
- **AppleScript**: `/Users/dylanlawless/Library/CloudStorage/GoogleDrive-dylanlawless1@gmail.com/My Drive/travel_engel_teufel/Genossenschaften/src/launch_checker_script.scpt`
- **Bash Script**: `/Users/dylanlawless/Library/CloudStorage/GoogleDrive-dylanlawless1@gmail.com/My Drive/travel_engel_teufel/Genossenschaften/src/auto_check_webpages.sh`

### launchd Configuration

The `launchd` job is configured to run the AppleScript every minute. The configuration is specified in the `com.user.launchchecker.plist` file located in the user's `LaunchAgents` directory. This setup ensures the script executes regularly, checking for any changes to the webpages.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.launchchecker</string>
    <key>ProgramArguments</key>
    <array>
        <string>osascript</string>
        <string>/Users/dylanlawless/Library/CloudStorage/GoogleDrive-dylanlawless1@gmail.com/My Drive/travel_engel_teufel/Genossenschaften/src/launch_checker_script.scpt</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>60</integer>
    <key>StandardErrorPath</key>
    <string>/tmp/com.user.launchchecker.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/com.user.launchchecker.out</string>
</dict>
</plist>
```

## Script Details
The main script, auto_check_webpages.sh, performs the following actions:

Fetches each webpage specified in the urls array.
Computes the MD5 checksum of the webpage content.
Compares the checksum with a previously stored value to detect changes.
Updates the stored checksums if changes are detected and logs this information.

## Security
Permissions for Terminal, iTerm2, and Script Editor have been configured to allow full disk access and automation, ensuring the scripts can run without interruption.

### System Permissions

To ensure the script runs correctly, specific system permissions must be granted:

- **Full Disk Access**: Grant this to Terminal and Script Editor to allow unrestricted file access.
- **Automation**: Allow Terminal and Script Editor to automate tasks and control other applications.

Follow the steps in System Preferences under Security & Privacy > Privacy to configure these settings.

## Usage
To start monitoring, ensure that the launchd job is loaded with:

`launchctl load ~/Library/LaunchAgents/com.user.launchchecker.plist`
Logs of the script's operations and any detected changes can be found in /tmp/com.user.launchchecker.out and /tmp/com.user.launchchecker.err.

## Change frequency

### Step 1: Edit the .plist File
`~/Library/LaunchAgents/com.user.launchchecker.plist`
First, make the necessary changes to your .plist file, such as adjusting the StartInterval key which defines the number of seconds between each run of the job. For example, if you wanted to change the interval to every 2 minutes (120 seconds), your StartInterval would look like this:

`<integer>120</integer>`

### Step 2: Unload the Current .plist
Before reloading the updated .plist, you need to unload the currently loaded version to clear the existing schedule:

`launchctl unload ~/Library/LaunchAgents/com.user.launchchecker.plist`

### Step 3: Reload the Updated .plist
After unloading, reload the .plist to apply the changes:

`launchctl load ~/Library/LaunchAgents/com.user.launchchecker.plist`
Step 4: Verify the Change
To ensure that your changes have taken effect, you can check the status of your launch agent:

`launchctl list | grep com.user.launchchecker`
This command will show the current status of your launch agent, confirming that it's loaded with the new configuration.

Additional Tips
Editing the .plist: Make sure your .plist file is well-formed and error-free. You can check its syntax using the plutil command:

`plutil ~/Library/LaunchAgents/com.user.launchchecker.plist`
This will tell you if there are any syntax errors in your file.

