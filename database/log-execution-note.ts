
import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

async function logNote() {
  const client = new pg.Client({
    connectionString: process.env.DATABASE_URL,
  });

  try {
    await client.connect();
    
    const note = {
      task_id: 'TASK-001',
      agent_id: 'DB-Specialist-Agent', // Me
      note: 'Task TASK-001 completed. Schema created with migration 002. Tests passed.',
      note_type: 'progress',
      metadata: JSON.stringify({
        migration: '002_create_core_schema.sql',
        tests: 'database/schema.test.ts',
        status: 'completed'
      })
    };

    await client.query(`
      INSERT INTO task_execution_notes (
        task_id, agent_id, note, note_type, metadata
      ) VALUES ($1, $2, $3, $4, $5)
    `, [note.task_id, note.agent_id, note.note, note.note_type, note.metadata]);

    console.log('Execution note logged successfully.');
  } catch (err) {
    console.error('Failed to log execution note:', err);
    process.exit(1);
  } finally {
    await client.end();
  }
}

logNote();
