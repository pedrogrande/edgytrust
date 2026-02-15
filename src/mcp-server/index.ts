import express from 'express';
import pg from 'pg';
import dotenv from 'dotenv';
import cors from 'cors';

dotenv.config();

const app = express();
const port = process.env.MCP_SERVER_PORT || 3000;

app.use(cors());
app.use(express.json());

const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
});

// Middleware for basic access control (placeholder)
const checkAgentAuth = (req: express.Request, res: express.Response, next: express.NextFunction) => {
  const agentId = req.body.agentId || req.query.agentId;
  if (!agentId) {
    return res.status(401).json({ error: 'Unauthorized: Agent ID required' });
  }
  // Future: Validate agentId against agent_profiles table
  next();
};

// Query Endpoint
app.post('/query', checkAgentAuth, async (req, res) => {
  const { table, agentId, filter } = req.body;

  // Allowed tables for reading (Reference + Immutable)
  const allowedTables = [
    'agent_specifications',
    'reference_documentation',
    'ontology_definitions',
    'raci_matrices',
    'artifact_schemas',
    'events',
    'verification_reports',
    'agent_artifacts',
    'task_execution_notes',
    'task_contracts',
    'agent_profiles'
  ];

  if (!allowedTables.includes(table)) {
    return res.status(403).json({ error: `Access denied: Cannot query table '${table}'` });
  }

  try {
    // Basic query builder (very simple for Phase 0)
    let query = `SELECT * FROM ${table}`;
    const values: any[] = [];
    
    if (filter) {
      const keys = Object.keys(filter);
      if (keys.length > 0) {
        query += ' WHERE ';
        query += keys.map((key, i) => `${key} = $${i + 1}`).join(' AND ');
        values.push(...Object.values(filter));
      }
    }
    
    query += ' LIMIT 100'; // Safety limit

    const result = await pool.query(query, values);
    res.json({ data: result.rows });
  } catch (err: any) {
    console.error('Query error:', err);
    res.status(500).json({ error: err.message });
  }
});

// Insert Endpoint
app.post('/insert', checkAgentAuth, async (req, res) => {
  const { table, agentId, data } = req.body;

  // Allowed tables for writing (Immutable only, scoped)
  const allowedWritableTables = [
    'task_execution_notes',
    'verification_reports',
    'agent_artifacts',
    'events' // Special case, usually triggered by system
  ];

  if (!allowedWritableTables.includes(table)) {
    return res.status(403).json({ error: `Access denied: Cannot write to table '${table}'` });
  }

  try {
    // Namespace scoping: Ensure agent_id in data matches authenticated agent
    if (data.agent_id && data.agent_id !== agentId) {
       return res.status(403).json({ error: 'Access denied: Cannot write data for another agent' });
    }
    
    // For tables that require agent_id/verifier_id/produced_by
    if (table === 'task_execution_notes' && !data.agent_id) data.agent_id = agentId;
    if (table === 'verification_reports' && !data.verifier_id) data.verifier_id = agentId;
    if (table === 'agent_artifacts' && !data.produced_by) data.produced_by = agentId;

    const keys = Object.keys(data);
    const columns = keys.join(', ');
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ');
    const values = Object.values(data);

    const query = `INSERT INTO ${table} (${columns}) VALUES (${placeholders}) RETURNING *`;
    
    const result = await pool.query(query, values);
    res.json({ success: true, data: result.rows[0] });
  } catch (err: any) {
    console.error('Insert error:', err);
    res.status(500).json({ error: err.message });
  }
});

// Health Check
app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'healthy', database: 'connected' });
  } catch (err: any) {
    res.status(500).json({ status: 'unhealthy', error: err.message });
  }
});

app.listen(port, () => {
  console.log(`MCP Server running on port ${port}`);
});
