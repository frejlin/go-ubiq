Section "Uninstall"
  # uninstall for all users
  setShellVarContext all

  # Delete (optionally) installed files
  {{range $}}Delete $INSTDIR\{{.}}
  {{end}}
  Delete $INSTDIR\uninstall.exe

  # Delete install directory
  rmDir $INSTDIR

  # Delete start menu launcher
  Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\Attach.lnk"
  Delete "$SMPROGRAMS\${APPNAME}\Uninstall.lnk"
  rmDir "$SMPROGRAMS\${APPNAME}"

  # Firewall - remove rules if exists
  SimpleFC::AdvRemoveRule "Gubiq incoming peers (TCP:30388)"
  SimpleFC::AdvRemoveRule "Gubiq outgoing peers (TCP:30388)"
  SimpleFC::AdvRemoveRule "Gubiq UDP discovery (UDP:30388)"

  # Remove IPC endpoint (https://github.com/ethereum/EIPs/issues/147)
  ${un.EnvVarUpdate} $0 "ETHEREUM_SOCKET" "R" "HKLM" "\\.\pipe\gubiq.ipc"

  # Remove install directory from PATH
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" $INSTDIR

  # Cleanup registry (deletes all sub keys)
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GROUPNAME} ${APPNAME}"
SectionEnd