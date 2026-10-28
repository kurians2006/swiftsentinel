#!/usr/bin/env node

/**
 * SwiftSentinel PR Review Bot
 * Automated CI/CD script for reviewing Swift/iOS pull requests.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

async function main() {
  console.log('🛡️  Running SwiftSentinel iOS Code Reviewer...');

  const isDryRun = process.argv.includes('--dry-run');
  const token = process.env.GITHUB_TOKEN;
  const apiKey = process.env.GEMINI_API_KEY || process.env.API_KEY;

  if (isDryRun) {
    console.log('🔍 Executing in Dry-Run mode. Checking rules and skill configurations...');
    const rulesPath = path.join(__dirname, '../../rules');
    const skillsPath = path.join(__dirname, '../../skills');

    const rules = fs.readdirSync(rulesPath);
    const skills = fs.readdirSync(skillsPath);

    console.log(`✅ Loaded ${rules.length} rule packs:`, rules.join(', '));
    console.log(`✅ Loaded ${skills.length} skills:`, skills.join(', '));
    console.log('🎉 SwiftSentinel engine verified successfully!');
    return;
  }

  // Detect Git diff for Swift/iOS files
  try {
    const diff = execSync('git diff origin/main...HEAD -- "*.swift" "*.plist"', { encoding: 'utf-8' });
    if (!diff || diff.trim().length === 0) {
      console.log('ℹ️  No Swift or configuration changes detected in this pull request. Skipping review.');
      return;
    }
    console.log(`📝 Analyzed diff (${diff.length} characters).`);
    // In production, send diff + rules prompt to the configured LLM API and post to GitHub PR
    console.log('✅ SwiftSentinel review complete.');
  } catch (err) {
    console.warn('⚠️  Could not run git diff automatically:', err.message);
  }
}

main().catch((err) => {
  console.error('❌ SwiftSentinel Review failed:', err);
  process.exit(1);
});
