# 🔎 Cloudflare Page Rules Counter

Identify zones with excess page rules you forgot about.

## 📝 Overview
This script allows you to count the number of page rules for each zone in your Cloudflare account. It provides a clear output to easily identify zones with 3 or more page rules.

## 🚀 Features
- Fetches all zones in your Cloudflare account
- Counts page rules for each zone
- Color-coded output for quick identification

## ⚙️ Prerequisites
- Cloudflare Global API Key
  Bash shell
- `curl` command-line tool
- `jq` command-line JSON processor

## 🛠️ Setup

1. Clone or download this repository to your local machine.

2. Open the script file `cf_rules.sh` in a text editor.

3. Replace the placeholder values with your Cloudflare credentials:
   - Replace `"your_cloudflare_email@example.com"` with your Cloudflare account email.
   - Replace `"your_global_api_key_here"` with your Cloudflare Global API Key.

   You can find your Global API Key here:  
   [Cloudflare API Tokens](https://dash.cloudflare.com/profile/api-tokens)

   **Note:** 🔒 The Global API Key provides full access to your Cloudflare account. Keep it secure and never share it publicly.

4. 💾 Save the changes to the script file.

5. 🔧 Make the script executable:
   ```bash
   chmod +x cf_rules.sh
   ```

## ▶️ Usage

Run the script from the command line:
```bash
./cf_rules.sh
```

The script will output a list of all your zones and the number of page rules for each zone. The output will be color-coded for easier identification of zones with more than 3 page rules.

### ⚠️ Important Notes

	•	🚨 This script uses the Cloudflare Global API Key, which has full access to your account. Consider using API Tokens for more granular control in production environments.
	•	⏲️ Be mindful of API rate limits when running this script frequently or on accounts with many zones.

📄 License

MIT License
