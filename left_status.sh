#!/bin/bash


function ip_address() {

    # Loop through the interfaces and check for the interface that is up.
    for file in /sys/class/net/*; do

        iface=$(basename $file);

        read status < $file/operstate;

        [ "$status" == "up" ] && ip addr show $iface | awk '/inet /{printf $2" "}'

    done

}

function cpu_temperature() {

    # Display the temperature of CPU core 0 and core 1.
    sensors | awk '/Core 0/{printf $3" "}/Core 1/{printf $3" "}'

}

function memory_usage() {

    if [ "$(which bc)" ]; then

        # Display used, total, and percentage of memory using the free command.
        read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')
        # Calculate the percentage of memory used with bc.
        percent=$(bc -l <<< "100 * $total / $used")
        # Feed the variables into awk and print the values with formating.
        awk -v u=$used -v t=$total -v p=$percent 'BEGIN {printf "%sMi/%sMi %.1f% ", t, u, p}'

    fi

}

function vpn_connection() {

    # Check for tun0 interface.
    [ -d /sys/class/net/tun0 ] && printf "%s " 'VPN*'

}

function battery_meter0() {

    if [ "$(which acpi)" ]; then

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

                # From 100% to 75% display color grey.
                100%|9[0-9]%|8[0-9]%|7[5-9]%) fgcolor='#[fg=brightgreen]'
                    ;;

                # From 74% to 50% display color green.
                7[0-4]%|6[0-9]%|5[0-9]%) fgcolor='#[fg=brightgrey]'
                    ;;

                # From 49% to 25% display color yellow.
                4[0-9]%|3[0-9]%|2[5-9]%) fgcolor='#[fg=brightyellow]'
                    ;;

                # From 24% to 0% display color red.
                2[0-4]%|1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]'
                    ;;
            esac

            # Display the percentage of charge the battery has.
            printf "%s " "${icon} ${fgcolor}${charging}${batt0}${fgdefault}"

        fi
    fi
}

function battery_meter1() {

    if [ "$(which acpi)" ]; then

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

                # From 100% to 75% display color grey.
                100%|9[0-9]%|8[0-9]%|7[5-9]%) fgcolor='#[fg=brightgreen]'
                    ;;

                # From 74% to 50% display color green.
                7[0-4]%|6[0-9]%|5[0-9]%) fgcolor='#[fg=brightgrey]'
                    ;;

                # From 49% to 25% display color yellow.
                4[0-9]%|3[0-9]%|2[5-9]%) fgcolor='#[fg=brightyellow]'
                    ;;

                # From 24% to 0% display color red.
                2[0-4]%|1[0-9]%|[0-9]%) fgcolor='#[fg=brightred]'
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
    ip_address
    cpu_temperature
    # vpn_connection
    # battery_meter0
    # battery_meter1
    # memory_usage
    # load_average
    # date_time

}

# Calling the main function which will call the other functions.
main
