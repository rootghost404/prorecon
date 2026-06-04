#!/bin/bash

# Color Codes for Terminal Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TARGET=$1

# Check for required target input
if [ -z "$TARGET" ]; then
    echo -e "${RED}[!] Usage: ./prorecon.sh target.com${NC}"
    exit 1
fi

# Function to check if a tool is installed
check_requirement() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}[!] Error: $1 is not installed. Please install $1 this tool first${NC}"
        exit 1
    fi
}

echo -e "${BLUE}[*] Checking tool installed...${NC}"
check_requirement "subfinder"
check_requirement "alterx"
check_requirement "httpx"
check_requirement "gau"
check_requirement "nuclei"
echo -e "${GREEN}[✓] All required tools are available!${NC}"

# Create output directory for the target
OUTPUT_DIR="recon_$TARGET"
mkdir -p $OUTPUT_DIR

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}      Starting 2026 Pro-AI Recon Framework...       ${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}[*] Target Domain: $TARGET${NC}"
echo -e "${YELLOW}[*] All results will be saved in: /$OUTPUT_DIR${NC}"
echo -e "${BLUE}====================================================${NC}"

# ----------------------------------------------------
# STEP 1: Subdomain Discovery (Subfinder)
# ----------------------------------------------------
echo -e "\n${GREEN}[+] Step 1: Gathering passive subdomains...${NC}"
subfinder -d $TARGET -all -recursive -silent -o $OUTPUT_DIR/raw_subs.txt
TOTAL_SUBS=$(wc -l < $OUTPUT_DIR/raw_subs.txt)
echo -e "${GREEN}[✓] Total subdomains discovered: $TOTAL_SUBS${NC}"

# ----------------------------------------------------
# STEP 2: Subdomain Permutations (AlterX)
# ----------------------------------------------------
echo -e "\n${GREEN}[+] Step 2: Generating smart permutations via AlterX...${NC}"
alterx -l $OUTPUT_DIR/raw_subs.txt -silent -o $OUTPUT_DIR/permutation_subs.txt
cat $OUTPUT_DIR/raw_subs.txt $OUTPUT_DIR/permutation_subs.txt | sort -u > $OUTPUT_DIR/all_combined_subs.txt
echo -e "${GREEN}[✓] Permutation completed. Combined target list created.${NC}"

# ----------------------------------------------------
# STEP 3: Probing and Tech Detection (Httpx)
# ----------------------------------------------------
echo -e "\n${GREEN}[+] Step 3: Filtering live hosts and detecting technologies...${NC}"
httpx -l $OUTPUT_DIR/all_combined_subs.txt -sc -title -td -silent -o $OUTPUT_DIR/live_hosts.txt
LIVE_SUBS=$(wc -l < $OUTPUT_DIR/live_hosts.txt)
echo -e "${GREEN}[✓] Live web hosts found: $LIVE_SUBS${NC}"

# ----------------------------------------------------
# STEP 4: Endpoint and URL Mining (Gau)
# ----------------------------------------------------
echo -e "\n${GREEN}[+] Step 4: Extracting historical URLs from archives...${NC}"
gau $TARGET --subs --o $OUTPUT_DIR/all_urls.txt
# Filtering only Javascript files for deep analysis
grep -iE "\.js$" $OUTPUT_DIR/all_urls.txt > $OUTPUT_DIR/js_files.txt
echo -e "${GREEN}[✓] URL mining done. JS files separated successfully.${NC}"

# ----------------------------------------------------
# STEP 5: Automated Vulnerability Scanning (Nuclei)
# ----------------------------------------------------
echo -e "\n${GREEN}[+] Step 5: Scanning live targets for High/Critical bugs...${NC}"
nuclei -l $OUTPUT_DIR/live_hosts.txt -tags cve,misconfig,panel -severity critical,high -silent -o $OUTPUT_DIR/nuclei_bugs.txt
echo -e "${GREEN}[✓] Nuclei scanning process finished.${NC}"

# ----------------------------------------------------
# Recon Mission Summary
# ----------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}               [✓] Recon Mission Complete!           ${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}1. View Live Hosts       : cat $OUTPUT_DIR/live_hosts.txt${NC}"
echo -e "${YELLOW}2. View JS Files List   : cat $OUTPUT_DIR/js_files.txt${NC}"
echo -e "${RED}3. View Potential Bugs  : cat $OUTPUT_DIR/nuclei_bugs.txt${NC}"
echo -e "${BLUE}====================================================${NC}"