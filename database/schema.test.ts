
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

describe('Database Schema', () => {
  let client: pg.Client;

  beforeAll(async () => {
    client = new pg.Client({
      connectionString: process.env.DATABASE_URL,
    });
    await client.connect();
  });

  afterAll(async () => {
    await client.end();
  });

  it('should have all required tables', async () => {
    const requiredTables = [
      'events',
      'verification_reports',
      'agent_artifacts',
      'task_execution_notes',
      'agent_specifications',
      'reference_documentation',
      'ontology_definitions',
      'raci_matrices',
      'artifact_schemas',
      'task_contracts',
      'agent_profiles'
    ];

    const res = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `);
    
    const tableNames = res.rows.map(r => r.table_name);
    requiredTables.forEach(table => {
      expect(tableNames).toContain(table);
    });
  });

  it('should enforce immutability on events table', async () => {
    const eventId = crypto.randomUUID();
    
    // Insert event
    await client.query(`
      INSERT INTO events (id, type, source, data)
      VALUES ($1, 'taskmarket.test.event', 'test-agent', '{"test": true}')
    `, [eventId]);

    // Attempt update
    try {
      await client.query(`
        UPDATE events SET source = 'modified' WHERE id = $1
      `, [eventId]);
      throw new Error('Update should have failed');
    } catch (err: any) {
      expect(err.message).toContain('This table is immutable');
    }

    // Attempt delete
    try {
      await client.query(`
        DELETE FROM events WHERE id = $1
      `, [eventId]);
      throw new Error('Delete should have failed');
    } catch (err: any) {
      expect(err.message).toContain('This table is immutable');
    }
  });

  it('should enforce constraints on verification_reports', async () => {
    // Attempt invalid score
    try {
      await client.query(`
        INSERT INTO verification_reports (
          task_id, verifier_id, verification_type, score, dimension_scores, feedback, recommendation
        ) VALUES (
          'TASK-TEST', 'agent-test', 'primary', 101, '{"capability":1,"accountability":1,"quality":1,"temporality":1,"context":1,"artifact":1}', 'feedback', 'APPROVE'
        )
      `);
      throw new Error('Should have failed constraint check');
    } catch (err: any) {
      expect(err.message).toContain('valid_score');
    }

    // Attempt missing dimensions
    try {
      await client.query(`
        INSERT INTO verification_reports (
          task_id, verifier_id, verification_type, score, dimension_scores, feedback, recommendation
        ) VALUES (
          'TASK-TEST', 'agent-test', 'primary', 50, '{"capability": 10}', 'feedback', 'APPROVE'
        )
      `);
      throw new Error('Should have failed constraint check');
    } catch (err: any) {
      expect(err.message).toContain('six_dimensions_present');
    }
  });

  it('should log task state changes to events', async () => {
    const taskId = `TASK-${Date.now()}`;
    
    // Create task
    await client.query(`
      INSERT INTO task_contracts (
        task_id, title, created_by, phase, status, acceptance_criteria, test_requirements, proof_requirements, six_dimensions, metadata
      ) VALUES (
        $1, 'Test Task', 'agent-test', 0, 'OPEN', '[]', '[]', '[]', 
        '{"capability":{},"accountability":{},"quality":{},"temporality":{},"context":{},"artifact":{}}', '{}'
      )
    `, [taskId]);

    // Update status
    await client.query(`
      UPDATE task_contracts SET status = 'CLAIMED', assigned_to = 'agent-worker' WHERE task_id = $1
    `, [taskId]);

    // Check events
    const res = await client.query(`
      SELECT type, data FROM events 
      WHERE type = 'taskmarket.task.statechange' 
      AND (data->>'task_id') = $1
    `, [taskId]);

    expect(res.rows.length).toBeGreaterThan(0);
    expect(res.rows[0].data.previous_status).toBe('OPEN');
    expect(res.rows[0].data.new_status).toBe('CLAIMED');
  });
});
