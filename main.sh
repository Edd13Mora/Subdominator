#!/bin/bash

# Check if the domain argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <domain> [path_to_dns_list] [path_to_resolver_list]"
  echo "Example: $0 example.com /home/kali/dns.txt /home/kali/resolver.txt"
  exit 1
fi

domain="$1"
mydnslist=${2:-"./mydnslist"}  # Default to "./mydnslist" if not specified
resolvers=${3:-"resolvers.txt"}  # Default to "resolvers.txt" if not specified

# Check if the provided mydnslist and resolvers files exist
if [ ! -f "$mydnslist" ]; then
  echo "Error: Dns file not found!"
  exit 1
fi

if [ ! -f "$resolvers" ]; then
  echo "Error: resolver file not found!"
  exit 1
fi

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
ascii_banner="${RED}
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⠶⢦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣯⣶⣿⣷⣾⣝⣷⠀⠀⠀⣀⣤⣤⣤⢤⣤⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⣿⡶⠿⠿⠿⠿⠿⣿⠀⣴⣿⣿⣵⣾⣴⣷⣶⣮⣭⣽⣻⣿⣦⣄⡀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠊⠡⠄⠈⠈⢀⢀⡔⠉⠉⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀
⠀⠀⠀⠀⠀⠀⣰⣶⠀⠀⠀⡠⠂⠅⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢰⡉⣸⣿⣿⢿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⣆⠀
⠀⠀⠀⠀⠀⠀⣿⣿⣆⠀⣼⢛⠒⢄⣀⢠⠄⠠⢂⣤⣤⣤⣤⠀⢀⣼⣿⣾⡿⠿⠿⠛⠛⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⡄
⠀⠀⠀⠀⠀⠀⢿⣿⠟⡁⠂⠈⡎⠎⠛⠁⢠⣤⣙⣿⣿⣿⣿⣿⠉⣿⣿⣿⠅⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠜⡡⠀⢀⡴⠊⠀⠀⠀⠀⠈⠘⣿⣿⣿⣟⣻⡿⣶⣟⣽⢃⠇⠀⠀⠀⣀⣠⣤⡀⠀⠈⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⣰⣾⢮⣤⡾⠋⡄⠑⠢⠐⠒⠄⡄⢠⣦⣍⣍⣉⡀⠘⣰⠈⣐⡁⠀⠀⢠⣾⣫⣾⣿⠃⠀⠀⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⣽⡇⣿⡟⠁⠄⣀⡀⠀⠀⠀⢀⠼⡿⣿⣿⣟⣷⣿⣖⢤⢔⡻⣘⢤⢰⣟⣽⣿⡿⠁⡀⠀⣠⣿⣿⣿⣿⣿⠏
⠀⠀⢀⣼⣿⣾⠋⡰⣤⣾⣵⣷⣤⣤⣭⡼⣽⢿⣻⡿⣯⣯⣛⠿⣹⢇⢲⢹⢋⣿⣿⣿⣿⡹⣖⣨⣴⣿⣿⣿⣿⣿⣟⠀
⢀⠴⡹⠿⠛⠁⣴⣯⣛⣭⠶⡻⣻⣝⡾⡟⢛⠫⢟⠺⡍⡖⣬⠚⣡⢺⡴⢩⢬⣿⣯⣷⣿⣿⣶⣿⣿⣿⣿⣿⣿⡟⠁⠀
⠘⣓⣃⣴⡻⡻⣭⣾⡵⢴⣯⡽⣇⣧⣾⡼⣧⣹⢾⡷⢧⠿⠯⠩⠷⠿⠷⢯⠧⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀
⠀⠈⠈⠈⠉⠀⠀⠀⠀⠀⠀⠉⠃⠈⠀⠀⠁⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠊⠙⠿⠿⠿⠟⠛⠋⠁
          @Edd13Mora - Sekera Team.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
${NC}"
# Display colored ASCII art banner
echo -e "$ascii_banner"
echo -e "${YELLOW}All human wisdom is summed up in two words; wait and hope.${NC}"

# Temporary File Names
tmp1="tmp1.txt"
massdns1="massdnslist"
massdns2="massdnslist2"

# Subdomain Enumeration
subfinder -d "$domain" -silent | sed '/www/d' > $tmp1
assetfinder "$domain" -subs-only | grep "$domain\$" | sed '/www/d' >> $tmp1
echo -e "${GREEN} + Subdomains Done!${NC}"

# Add DNS words in the top-level domain example: xxx.domain.com
awk -v host="$domain" '{print $0"."host}' "$mydnslist" | sed '/www/d' > $massdns1
massdns $massdns1 -r "$resolvers" -o S -t A -q | awk -F". " '{print $1}' | sort -u >> $tmp1
echo -e "${GREEN} + DNS enumeration done!${NC}"

# Deep Host Enumeration
awk '/(\.[\w-]+){3,6}$/' $tmp1 > deephosts.txt
echo -e "${GREEN} + Deep host enumeration done!${NC}"

# DNS Enumeration on Deep Hosts
awk -v dnslist="$mydnslist" '{
    host=$1
    while (getline line < dnslist) {
        print line"."host
    }
}' deephosts.txt | sed '/www/d' > $massdns2
massdns $massdns2 -r "$resolvers" -o S -t A -q | awk -F". " '{print $1}' | sort -u >> $tmp1
echo -e "${GREEN} + Running DNS enumeration on deep hosts done!${NC}"

# Httprobe
httprobe < "$tmp1" | sort -u >> all_assets.txt
line_count=$(wc -l < all_assets.txt)

echo -e "${GREEN}Process completed! $line_count check all_assets.txt file.${NC}"

# Remove temporary files
rm -f $tmp1 $massdns1 $massdns2 deephosts.txt
