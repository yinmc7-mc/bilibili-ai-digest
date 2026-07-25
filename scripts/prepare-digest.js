#!/usr/bin/env node

/**
 * Bilibili Digest - Prepare Digest
 *
 * Similar to zarazhangrui's follow-builders architecture:
 * Gathers everything the LLM needs to produce a digest:
 * - Fetches the Bilibili feed
 * - Loads prompts
 * - Reads user config
 * - Outputs a single JSON blob to stdout
 */

import { readFile } from 'fs/promises';
import { existsSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';

// Constants
const USER_DIR = join(homedir(), '.bilibili-digest');
const CONFIG_PATH = join(USER_DIR, 'config.json');
const FEED_PATH = join(homedir(), 'bilibili-digest/feed/feed-bilibili.json');
const PROMPTS_DIR = join(homedir(), 'bilibili-digest/prompts');

const PROMPT_FILES = [
  'summarize-bilibili-videos.md',
  'digest-intro-bilibili.md',
  'translate-bilibili.md'
];

// Helper functions
async function fetchJSON(url) {
  try {
    const response = await fetch(url);
    if (!response.ok) return null;
    return await response.json();
  } catch (error) {
    return null;
  }
}

async function readTextFile(filePath) {
  try {
    return await readFile(filePath, 'utf-8');
  } catch (error) {
    return null;
  }
}

async function readPrompts() {
  const prompts = {};

  for (const filename of PROMPT_FILES) {
    const key = filename.replace('.md', '').replace(/-/g, '_');

    // Try user custom prompts first
    const userPath = join(USER_DIR, 'prompts', filename);
    let content = await readTextFile(userPath);

    // Fall back to default prompts
    if (!content) {
      const defaultPath = join(PROMPTS_DIR, filename);
      content = await readTextFile(defaultPath);
    }

    if (content) {
      prompts[key] = content;
    }
  }

  return prompts;
}

// Main function
async function main() {
  const errors = [];

  // 1. Read user config
  let config = {
    language: 'zh',
    frequency: 'daily',
    delivery: { method: 'feishu' }
  };

  if (existsSync(CONFIG_PATH)) {
    try {
      config = JSON.parse(await readFile(CONFIG_PATH, 'utf-8'));
    } catch (err) {
      errors.push(`Could not read config: ${err.message}`);
    }
  }

  // 2. Read Bilibili feed
  let feedData = { bilibili: [] };
  if (existsSync(FEED_PATH)) {
    try {
      feedData = JSON.parse(await readFile(FEED_PATH, 'utf-8'));
    } catch (err) {
      errors.push(`Could not read feed: ${err.message}`);
    }
  } else {
    errors.push('Feed file not found - run generate-bilibili-feed.js first');
  }

  // 3. Load prompts
  const prompts = await readPrompts();

  // 4. Build the output JSON
  const output = {
    status: 'ok',
    generatedAt: new Date().toISOString(),

    // User preferences
    config: {
      language: config.language || 'zh',
      frequency: config.frequency || 'daily',
      delivery: config.delivery || { method: 'feishu' }
    },

    // Content to remix
    bilibili: feedData.bilibili || [],

    // Stats
    stats: {
      totalCreators: feedData.bilibili?.length || 0,
      totalVideos: (feedData.bilibili || []).reduce((sum, creator) => sum + creator.videos.length, 0),
      feedGeneratedAt: feedData.generatedAt || null
    },

    // Prompts for the LLM
    prompts,

    // Non-fatal errors
    errors: errors.length > 0 ? errors : undefined
  };

  console.log(JSON.stringify(output, null, 2));
}

main().catch(err => {
  console.error(JSON.stringify({
    status: 'error',
    message: err.message
  }));
  process.exit(1);
});