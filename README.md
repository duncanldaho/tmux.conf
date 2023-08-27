# tmux.conf

A tmux.conf with several status bar options. Uncomment the functions at the
bottom of the left/right scripts to customize the status bar. Available status
bar options:

- IP address
- CPU temperature
- VPN connection
- Battery meters
- Memory usage
- Load average
- Date and time

## Set up

1. Download or clone the code.
```
git clone https://github.com/duncanldaho/tmux.conf && cd tmux.conf
```
2. Copy .tmux.conf to your home directory.
```
cp .tmux.conf ~/.tmux.conf
```
3. Install the acpi package from your upstream package manager.
```
# Debian/Ubuntu
sudo apt install acpi
```
