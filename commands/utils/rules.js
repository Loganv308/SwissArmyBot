import { SlashCommandBuilder } from 'discord.js';

export const data = new SlashCommandBuilder()
    .setName('rules')
    .setDescription('Provides the server rules.');

export async function execute(interaction) {
    await interaction.reply({
        content: "Here are the server rules:\n\n1. Be respectful to all members.\n2. No spamming or flooding the chat.\n3. No drama please, leave it outside of this server.\n4. No free advertisement, run it by the owner first.\n5. Post whatever just please no NSFW images (porn, gore, etc.)\n6. Keep political talk to a minimum, nobody wants to hear that garbage. \n\nFailure to follow these rules may result in a warning, mute, or ban depending on the severity of the offense.",
        ephemeral: true
    });
}