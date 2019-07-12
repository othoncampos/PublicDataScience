#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import render_template
from app import app
from app import indexPage
from app import listaEstado
from app.models import business
from app.models.forms import LoginForm

@app.route("/")
@app.route("/index")
def index():
	return render_template( "index.html", index=indexPage)

@app.route("/quemsomos")
def quemSomos():
	return render_template( "QuemSomos.html", index=indexPage)

@app.route("/projetos")
def projetos():
	return render_template( "projetos.html", index=indexPage)

@app.route("/estado/<uf>")
def estado(uf):
	e = None
	if ( listaEstado.verificarEstado( uf ) ):
		e = listaEstado.obterEstado( uf )
	else:
		e = business.Estado( uf )
		listaEstado.inserirEstado( e )
	return render_template( "estado.html", index=indexPage, estado=e)

@app.route("/outlier/<uf>")
def outlier(uf):
	e = None
	if ( listaEstado.verificarEstado( uf ) ):
		e = listaEstado.obterEstado( uf )
	else:
		e = business.Estado( uf )
		listaEstado.inserirEstado( e )
	return render_template( "outlier.html", index=indexPage, estado=e)

@app.route("/teste")
def teste():
	return render_template( "teste.html", index=indexPage)

@app.route("/login", methods=['POST', 'GET'])
def login():
	form = LoginForm()
	if form.validate_on_submit():
		print(form.username.data)
		print(form.password.data)
		print(form.remember_me.data)
	else:
		print(form.errors)
	return render_template( "login.html", form=form)