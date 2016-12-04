from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime,timedelta
import os
#from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://docker:docker@192.168.99.100:5432/docker'
db = SQLAlchemy(app)

if db is None:
	@app.route('/')
	def index():
	    return "DB not found!"
else:
	#--------------------------------------------------------------------
	class Word (db.Model):
	    __tablename__ = "word"
	    id = db.Column('id', db.Integer, primary_key=True)
	    word = db.Column('word', db.Unicode)
	    creation_date = db.Column('creation_date', db.Date, default=datetime.utcnow)
	#--------------------------------------------------------------------
	db.create_all()

	@app.route('/')
	def index():
	    words=Word.query.all()
	    return render_template('data.html',words=Word.query.all())

	@app.route('/Prueba')
	def prueba():
	    toAdd = Word(word=u'Funciona!') 
	    db.session.add(toAdd)
	    db.session.commit()
	    return toAdd.word + " agregada correctamente."

	@app.route('/<palabra>')
	def addingWord(palabra):
	    toAdd = Word(word=palabra)
	    db.session.add(toAdd)
	    db.session.commit()
	    return palabra + " agregada correctamente."


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
