//import { query } from '../database.js';
const { query } = require('../database');
// Funções do controller

const path = require('path');

exports.abrirCrudCargo = (req, res) => {
  console.log('cargoController - Rota /abrirCrudCargo - abrir o crudCargo');
  res.sendFile(path.join(__dirname, '../../frontend/cargo/cargo.html'));
}

exports.listarCargos = async (req, res) => {
  try {
    const result = await query('SELECT * FROM cargo ORDER BY idcargo');
    // console.log('Resultado do SELECT:', result.rows);//verifica se está retornando algo
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar cargos:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}


exports.criarCargo = async (req, res) => {
  //  console.log('Criando cargo com dados:', req.body);
  try {
    const { idcargo, nomecargo } = req.body;

    // Validação básica
    if (!nomecargo || !nota_maxima_cargo || !texto_complementar_cargo) {
      return res.status(400).json({
        error: 'Texto, nota máxima e texto complementar são obrigatórios'
      });
    }

    const result = await query(
      'INSERT INTO cargo (idcargo, nomecargo) VALUES ($1, $2) RETURNING *',
      [idcargo, nomecargo]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao criar cargo:', error);

   

    // verifica se n ta nulo
    if (error.code === '23502') {
      return res.status(400).json({
        error: 'Dados obrigatórios não fornecidos'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.obterCargo = async (req, res) => {
  try {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
      return res.status(400).json({ error: 'ID deve ser um número válido' });
    }

    const result = await query(
      'SELECT * FROM cargo WHERE idcargo = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Cargo não encontrada' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao obter cargo:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.atualizarCargo = async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const { nomecargo } = req.body;

   
    // Verifica se a cargo existe
    const existingPersonResult = await query(
      'SELECT * FROM cargo WHERE idcargo = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Cargo não encontrada' });
    }

    // Constrói a query de atualização dinamicamente para campos não nulos
    const currentPerson = existingPersonResult.rows[0];
    const updatedFields = {
      nomecargo: nomecargo !== undefined ? nomecargo : currentPerson.nomecargo     
    };

    // Atualiza a cargo
    const updateResult = await query(
      'UPDATE cargo SET nomecargo = $1 WHERE idcargo = $2 RETURNING *',
      [updatedFields.nomecargo, id]
    );

    res.json(updateResult.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar cargo:', error);

  

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.deletarCargo = async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    // Verifica se a cargo existe
    const existingPersonResult = await query(
      'SELECT * FROM cargo WHERE idcargo = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Cargo não encontrada' });
    }

    // Deleta a cargo (as constraints CASCADE cuidarão das dependências)
    await query(
      'DELETE FROM cargo WHERE idcargo = $1',
      [id]
    );

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar cargo:', error);

    // Verifica se é erro de violação de foreign key (dependências)
    if (error.code === '23503') {
      return res.status(400).json({
        error: 'Não é possível deletar cargo com dependências associadas'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

// Função adicional para buscar cargo por email
exports.obterCargoPorEmail = async (req, res) => {
  try {
    const { email } = req.params;

    if (!email) {
      return res.status(400).json({ error: 'Email é obrigatório' });
    }

    const result = await query(
      'SELECT * FROM cargo WHERE nota_maxima_cargo = $1',
      [email]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Cargo não encontrada' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao obter cargo por email:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

