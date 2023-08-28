# tmux.conf

A tmux.conf with several status bar options. Available status bar options:

- IP address
- CPU temperature (whole or individual cores)
- Memory usage
- VPN connection
- Battery meters
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
3. Uncomment the functions under 'main' to fit your needs for the left and right
status scripts.
