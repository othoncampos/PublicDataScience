from app import db

class User(db.Model):
	__tablename__ = 'users'

	id = db.Column(db.Integer, primary_key=True)
	username = db.Column(db.String(80), nullable=False, unique=True)
	password = db.Column(db.String(20), nullable=False)
	name = db.Column(db.String(80), nullable=False)
	email = db.Column(db.String(100), nullable=False, unique=True)

    def __repr__(self):
        return '<User %r>' % self.username

	def __init__(self, username, password, name, email):
		self.username = username
		self.password = password
		self.name = name
		self.email = email

class Post(db.Model):
	__tablename__ = 'posts'

	id = db.Column(db.Integer, primary_key=True)
	content = db.Column(db.Text, nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey('users.id') )

    user = db.relationship('User', foreign_key=user_id)

    def __repr__(self):
        return '<Post %r>' % self.id

	"""docstring for Use"""
	def __init__(self, content, user_id):
		self.content = content
		self.user_id = user_id

class Follow(db.Model):
	__tablename__ = 'follow'

	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.Integer, db.ForeignKey('users.id') )
	follower_id = db.Column(db.Integer, db.ForeignKey('users.id') )
	
    user = db.relationship('User', foreign_key=user_id)
    follower = db.relationship('User', foreign_key=follower_id)

    def __repr__(self):
        return '<Follow %r>' % self.id

	"""docstring for Use"""
	def __init__(self, user_id, follower_id):
		self.user_id = user_id
		self.follower_id = follower_id

