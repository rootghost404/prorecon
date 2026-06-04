# Pro-AI Recon Framework (2026 Edition)

An automated web reconnaissance pipeline tailored for bug bounty hunters and security professionals. This wrapper coordinates multiple modern OSINT and active scanning tools into a structured framework.

# Core Language Requirement && Install tool dependencies via Go
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

```bash
go install -v github.com/projectdiscovery/alterx/cmd/alterx@latest
```
```bash
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```
```bash
go install -v github.com/lc/gau/v2/cmd/gau@latest
```

```bash
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

## ProRecon Installation & Setup 

1. Clone the repository:
```bash
git clone https://github.com/rootghost404/prorecon.git 

```

2. go to directory
```bash
cd prorecon 

```

3. permission this file
```bash
chmod +x prorecon.sh 

```

4. run commnad
```bash
./prorecon.sh target.com 

```