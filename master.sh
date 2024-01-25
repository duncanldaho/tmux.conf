#!/bin/bash


function ip_address() {

    # Loop through the interfaces and check for the interface that is up.
    for file in /sys/class/net/*; do

        iface=$(basename $file);

        read status < $file/operstate;

        [ "$status" == "up" ] && ip addr show $iface | awk '/inet /{printf $2" "}'

    done

}

function cpu_temperature_whole() {

    # Display the temperature of the whole CPU.
    sensors | awk '/Package id 0/{printf $4" "}'

}

function cpu_temperature_cores() {

    # Display the temperature of CPU core 0 and core 1.
    sensors | awk '/Core 0/{printf $3" "}/Core 1/{printf $3" "}'

}

function memory_usage_mebibits() {

    if [ "$(which free)" ]; then

        # Display used, total, and percentage of memory using the free command.
        read total used <<< $(free -m | awk '/Mem/{printf $2" "$3}')
        # Calculate the percentage of memory used.
        percent=$((100*$used/$total))
        # Feed the variables into awk and print the values with formating.
        awk -v t=$total -v u=$used 'BEGIN {printf "%sMi/%sMi ", u, t}'

    fi

}

function memory_usage_percent() {

    if [ "$(which free)" ]; then

        # Display used, total, and percentage of memory using the free command.
        read total used <<< $(free -m | awk '/Mem/{printf $2" "$3}')
        # Calculate the percentage of memory used.
        percent=$((100*$used/$total))
        # Feed the variables into awk and print the values with formating.
        awk -v p=$percent 'BEGIN {printf "~%s%% ", p}'

    fi

}

function vpn_connection() {

    # Check for tun0 interface.
    [ -d /sys/class/net/tun0 ] && printf "%s " 'VPN*'

}

function energy-rate-batt0() {

    if [ "$(which upower)" ]; then

    # Check for existence of a battery.
    if [ -x /sys/class/power_supply/BAT0 ] ; then

        local batt0rate=$(upower -i $(upower -e | grep BAT0) | awk '/energy-rate/ {print $2}')

        # Display the energy usage.
        printf "%s " "${batt0rate:0:4}W"

        fi
    fi
}

function energy-rate-batt1() {

    if [ "$(which upower)" ]; then

    # Check for existence of a battery.
    if [ -x /sys/class/power_supply/BAT1 ] ; then

        local batt1rate=$(upower -i $(upower -e | grep BAT1) | awk '/energy-rate/ {print $2}')

        # Display the energy usage.
        printf "%s " "${batt1rate:0:4}W"

        fi
    fi
}

function battery_meter0() {

    if [ "$(which upower)" ]; then

        # Set the default color to the local variable fgdefault.
        local fgdefault='#[default]'

        if [ "$(cat /sys/class/power_supply/AC/online)" == 1 ] ; then

            local icon='🗲'
            local charging='+'

        else

            local icon=''
            local charging='-'
        fi

        # Check for existence of a battery.
        if [ -x /sys/class/power_supply/BAT0 ] ; then

            local batt0=$(upower -i $(upower -e | grep BAT0) | awk '/percentage/{print $2}')

            case $batt0 in

                # From 100% to 80% display color bright green.
                100%|9[0-9]%|8[0-9]%) fgcolor='#[fg=brightgreen]'
                    ;;

                # From 79% to 40% display color green.
                7[0-9]%|6[0-9]%|5[0-9]%|4[0-9]%) fgcolor='#[fg=brightgrey]'
                    ;;

                # From 39% to 20% display color yellow.
                3[0-9]%|2[0-9]%) fgcolor='#[fg=brightyellow]'
                    ;;

                # From 19% to 0% display color red.
                1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]'
                    ;;
            esac

            # Display the percentage of charge the battery has.
            printf "%s " "${icon} ${fgcolor}${charging}${batt0}${fgdefault}"

        fi
    fi
}

function battery_meter1() {

    if [ "$(which upower)" ]; then

        # Set the default color to the local variable fgdefault.
        local fgdefault='#[default]'

        if [ "$(cat /sys/class/power_supply/AC/online)" == 1 ] ; then

            local icon='🗲'
            local charging='+'

        else

            local icon=''
            local charging='-'
        fi

        # Check for existence of a battery.
        if [ -x /sys/class/power_supply/BAT1 ] ; then

            local batt1=$(upower -i $(upower -e | grep BAT1) | awk '/percentage/{print $2}')

            case $batt1 in

                # From 100% to 80% display color bright green.
                100%|9[0-9]%|8[0-9]%) fgcolor='#[fg=brightgreen]'
                    ;;

                # From 79% to 40% display color green.
                7[0-9]%|6[0-9]%|5[0-9]%|4[0-9]%) fgcolor='#[fg=brightgrey]'
                    ;;

                # From 39% to 20% display color yellow.
                3[0-9]%|2[0-9]%) fgcolor='#[fg=brightyellow]'
                    ;;

                # From 19% to 0% display color red.
                1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]'
                    ;;
            esac

            # Display the percentage of charge the battery has.
            printf "%s " "${fgcolor}${charging}${batt1}${fgdefault}"

        fi
    fi
}

function load_average() {

    printf "%s " "$(uptime | awk -F: '{printf $NF}' | tr -d ',')"

}

function date_time() {

    printf "%s" "$(date +'%Y-%m-%d %H:%M:%S %Z')"

}

function main() {

    # Comment out any function you do not need.
    # ip_address
    # cpu_temperature_whole
    # cpu_temperature_cores
    # memory_usage_mebibits
    # memory_usage_percent
    # vpn_connection
    # energy-rate-batt0
    # energy-rate-batt1
    # battery_meter0
    # battery_meter1
    # load_average
    # date_time

}

# Calling the main function which will call the other functions.
main
