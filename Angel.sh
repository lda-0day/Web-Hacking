#!/bin/bash

# Define global variables
echo '''
 _______  _        _______  _______  _       
(  ___  )( (    /|(  ____ \(  ____ \( \      
| (   ) ||  \  ( || (    \/| (    \/| (      
| (___) ||   \ | || |      | (__    | |      
|  ___  || (\ \) || | ____ |  __)   | |      
| (   ) || | \   || | \_  )| (      | |      
| )   ( || )  \  || (___) || (____/\| (____/\
|/     \||/    )_)(_______)(_______/(_______/
'''                                             

output_file="http_requests.txt"

# Check if a command exists, otherwise prompt to install
check_command() {
    command_name="$1"
    if ! command -v "$command_name" &> /dev/null; then
        echo "Error: '$command_name' command is not installed. Please install it to continue."
        exit 1
    fi
}

# Task functions
perform_whois_lookup() {
    check_command "whois"
    read -p "Enter target URL: " target_url
    echo "[*] Performing Whois lookup for $target_url..."
    whois "$target_url"
}

perform_dns_enumeration() {
    check_command "nslookup"
    read -p "Enter target URL: " target_url
    echo "[*] Performing DNS enumeration for $target_url..."
    nslookup "$target_url"
}

perform_subdomain_enumeration() {
    check_command "subfinder"
    read -p "Enter target URL: " target_url
    echo "[*] Performing subdomain enumeration for $target_url..."
    subfinder -d "$target_url"
}

perform_http_header_analysis() {
    check_command "curl"
    read -p "Enter target URL: " target_url
    echo "[*] Performing HTTP header analysis for $target_url..."
    curl -I "$target_url"
}

perform_directory_file_enumeration() {
    check_command "gobuster"
    read -p "Enter target URL: " target_url
    read -p "Enter wordlist file path: " wordlist
    echo "[*] Performing directory and file enumeration for $target_url..."
    gobuster dir -u "$target_url" -w "$wordlist"
}

perform_port_scanning() {
    check_command "nmap"
    read -p "Enter target URL: " target_url
    echo "[*] Performing port scanning for $target_url..."
    nmap -p- "$target_url"
}

perform_ssl_tls_scanning() {
    check_command "sslscan"
    read -p "Enter target URL: " target_url
    read -p "Enter output file path: " output
    echo "[*] Performing SSL/TLS scanning for $target_url..."
    sslscan "$target_url" > "$output"
}

perform_cms_detection() {
    check_command "wpscan"
    read -p "Enter target URL: " target_url
    echo "[*] Performing CMS detection for $target_url..."
    wpscan --url "$target_url"
}

perform_vulnerability_scanning() {
    check_command "nikto"
    read -p "Enter target URL: " target_url
    echo "[*] Performing vulnerability scanning for $target_url..."
    nikto -h "$target_url"
}

perform_tamper_verb() {
    echo "[*] Performing tamper verb..."
    read -p "Enter the URL: " url

    if [ -z "$url" ]; then
        echo "URL is not provided."
        return 1  
    fi

    for method in GET POST PUT DELETE HEAD; do
        response=$(curl -s -k "$url" -X "$method" -o /dev/null -w '%{http_code} - %{size_download}')
        echo "$method: $response"
        echo "$method: $response" >> "$output_file"  
    done

    echo "Results saved to $output_file"
}
# Main Script

while true; do
    echo "[*] Select an option:"
    echo "1. Perform Whois lookup"
    echo "2. Perform DNS enumeration"
    echo "3. Perform subdomain enumeration"
    echo "4. Perform HTTP header analysis"
    echo "5. Perform directory and file enumeration"
    echo "6. Perform port scanning"
    echo "7. Perform SSL/TLS scanning"
    echo "8. Perform CMS detection"
    echo "9. Perform vulnerability scanning"
    echo "10. Perform Tamper Verb"
    echo "0. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) perform_whois_lookup ;;
        2) perform_dns_enumeration ;;
        3) perform_subdomain_enumeration ;;
        4) perform_http_header_analysis ;;
        5) perform_directory_file_enumeration ;;
        6) perform_port_scanning ;;
        7) perform_ssl_tls_scanning ;;
        8) perform_cms_detection ;;
        9) perform_vulnerability_scanning ;;
        10) perform_tamper_verb ;;
        0)
            echo "[*] Exiting..."
            exit 0
            ;;
        *)
            echo "[!] Invalid choice. Please enter a valid option."
            ;;
    esac

    while true; do
        read -p "Do you want to perform another action? (Y/N): " continue_option
        case $continue_option in
            [Yy]) break ;;
            [Nn])
                echo "[*] Reconnaissance completed."
                exit 0
                ;;
            *)
                echo "[!] Invalid choice. Please enter Y or N."
                ;;
        esac
    done
done