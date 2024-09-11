# db_manager.rb
require 'sqlite3'
require 'thor'

# Classe principal que gerencia o banco de dados
class DBManager < Thor
  DB_NAME = 'contacts.db'

  def initialize(*args)
    super
    @db = SQLite3::Database.new DB_NAME
    create_contacts_table
  end

  # Comando para adicionar um contato
  desc "add NAME EMAIL PHONE", "Adiciona um novo contato"
  def add(name, email, phone)
    @db.execute("INSERT INTO contacts (name, email, phone) VALUES (?, ?, ?)", [name, email, phone])
    puts "Contato adicionado: #{name}, #{email}, #{phone}"
  end

  # Comando para listar todos os contatos
  desc "list", "Lista todos os contatos"
  def list
    rows = @db.execute("SELECT * FROM contacts")
    puts "ID | Nome | Email | Telefone"
    rows.each do |row|
      puts row.join(" | ")
    end
  end

  # Comando para atualizar um contato pelo ID
  desc "update ID NAME EMAIL PHONE", "Atualiza um contato existente"
  def update(id, name, email, phone)
    @db.execute("UPDATE contacts SET name = ?, email = ?, phone = ? WHERE id = ?", [name, email, phone, id])
    puts "Contato atualizado: ID #{id}, Nome: #{name}, Email: #{email}, Telefone: #{phone}"
  end

  # Comando para deletar um contato pelo ID
  desc "delete ID", "Deleta um contato pelo ID"
  def delete(id)
    @db.execute("DELETE FROM contacts WHERE id = ?", [id])
    puts "Contato deletado: ID #{id}"
  end

  private

  # Método para criar a tabela de contatos se não existir
  def create_contacts_table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS contacts (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT
      );
    SQL
  end
end

DBManager.start(ARGV)
