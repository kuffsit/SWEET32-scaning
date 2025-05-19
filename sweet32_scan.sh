#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

for cmd in subfinder nmap; do
  if ! command -v $cmd &>/dev/null; then
    echo -e "${RED}[-] $cmd is not installed. Please install it.${NC}"
    exit 1
  fi
done

read -p $'\e[34mEnter path to domain file (e.g. domains.txt): \e[0m' domain_file
read -p $'\e[34mEnter port to scan (default 443): \e[0m' port
port=${port:-443}

if [[ ! -f "$domain_file" ]]; then
  echo -e "${RED}[-] File not found: $domain_file${NC}"
  exit 1
fi

tmp_subs=$(mktemp)

echo -e "${YELLOW}[+] Collecting subdomains and checking for SWEET32...${NC}"
printf "%-35s | %-15s | %-25s\n" "Subdomain" "Port Status" "SWEET32 Status"
printf "%s\n" "----------------------------------------------------------------------------------------------"

while read root_domain; do
  echo -e "${YELLOW}[i] Running subfinder on ${root_domain}...${NC}"
  subfinder -silent -d "$root_domain" >> "$tmp_subs"
done < "$domain_file"

sort -u "$tmp_subs" > "$tmp_subs.sorted"

while read sub; do
  status=$(nmap -Pn -p "$port" "$sub" | grep "^$port" | awk '{print $2}')
  
  if [[ "$status" == "closed" || "$status" == "filtered" || -z "$status" ]]; then
    printf "\033[0;33m%-35s | %-15s | %-25s\033[0m\n" "$sub" "$status" "Not Tested"
  else
    result=$(nmap -Pn -T5 -sV --script ssl-enum-ciphers -p "$port" "$sub" | grep "64-bit block cipher 3DES vulnerable to SWEET32 attack")
    
    if [[ -z "$result" ]]; then
      printf "\033[0;32m%-35s | %-15s | %-25s\033[0m\n" "$sub" "$status" "No Vulnerability"
    else
      printf "\033[0;31m%-35s | %-15s | %-25s\033[0m\n" "$sub" "$status" "VULNERABLE to SWEET32"
    fi
  fi
done < "$tmp_subs.sorted"

rm "$tmp_subs" "$tmp_subs.sorted"
