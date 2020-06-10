# code by Rodrigo Miranda (rodrigo.qmiranda@gmail.com)
# and Josicleda Galvincio (josicleda@gmail.com)

import os, sys, numpy

class SamplesSwatpy(object):
	def __init__(self):
		self.p = self.p()
		self.n = self.n()
		self.procs = self.procs()
		self.sims = self.sims()

	def p(self):
		try:
			prefix = sys.argv[1]
			p = sys.argv[2]
		except:
			raise SyntaxError('invalid syntax')
		if prefix == '--p':
			try:
				return(int(p))
			except:
				raise NameError('value not valid')
		else:
			raise SyntaxError('invalid syntax')

	def n(self):
		try:
			prefix = sys.argv[3]
			n = sys.argv[4]
		except:
			raise SyntaxError('invalid syntax')
		if prefix == '--n':
			try:
				return(int(n)-1)
			except:
				raise NameError('value not valid')
		else:
			raise SyntaxError('invalid syntax')

	def procs(self):
		try:
			prefix = sys.argv[5]
			procs = sys.argv[6]
		except:
			raise SyntaxError('invalid syntax')
		if prefix == '--procs':
			try:
				return(int(procs))
			except:
				raise NameError('value not valid')
		else:
			raise SyntaxError('invalid syntax')

	def sims(self):
		try:
			prefix = sys.argv[7]
			sims = sys.argv[8]
		except:
			raise SyntaxError('invalid syntax')
		if prefix == '--sims':
			try:
				return(int(sims))
			except:
				raise NameError('value not valid')
		else:
			raise SyntaxError('invalid syntax')

	def get_sim(self):
		it = numpy.array(range(1,self.sims+1))
		it = numpy.array_split(it,self.procs)
		pair = [(numpy.min(n),numpy.max(n)) for n in it][self.n]
		return(pair[self.p])

if __name__ == "__main__":
	sys.exit(SamplesSwatpy().get_sim())

# SamplesSwatpy.py --p <min/max> --n <current proc> --procs <number of procs> --sims <number of sims>