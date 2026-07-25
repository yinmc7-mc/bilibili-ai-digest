#!/usr/bin/env node

/**
 * Bilibili Digest - Deliver
 *
 * Delivers the digest to the configured channel (Feishu, etc.)
 */

import { readFile } from 'fs/promises';
import { execSync } from 'child_process';

// Main delivery function
async function deliver() {
  try {
    // Read the digest content from stdin or file argument
    let digestContent = '';

    if (process.argv.includes('--file')) {
      const fileIndex = process.argv.indexOf('--file');
      const filePath = process.argv[fileIndex + 1];
      digestContent = await readFile(filePath, 'utf-8');
    } else {
      // Read from stdin
      digestContent = await new Promise((resolve) => {
        let data = '';
        process.stdin.on('data', (chunk) => { data += chunk; });
        process.stdin.on('end', () => { resolve(data); });
      });
    }

    // Deliver via OpenClaw to Feishu
    const command = `echo '${digestContent.replace(/'/g, "\\'")}' | openclaw agent --message "$(cat)" --agent main`;

    try {
      execSync(command, { stdio: 'inherit' });
      console.log('✅ Digest delivered to Feishu successfully!');
    } catch (error) {
      // Fallback: output to stdout
      console.log('⚠️  Feishu delivery failed, showing digest here:');
      console.log(digestContent);
      console.log('\n💡 Tip: Make sure OpenClaw Feishu integration is properly configured.');
    }

  } catch (error) {
    console.error('❌ Delivery failed:', error.message);
    process.exit(1);
  }
}

deliver();