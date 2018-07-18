# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Instrument.create([
  { name: 'Baixo', icon: '/icons/bass-guitar.svg' },
  { name: 'Percussão', icon: '/icons/conga.svg' },
  { name: 'Bateria', icon: '/icons/drums.svg' },
  { name: 'Guitarra', icon: '/icons/electric-guitar-1.svg' },
  { name: 'Violão', icon: '/icons/guitar.svg' },
  { name: 'Violino', icon: '/icons/violin.svg' },
  { name: 'Violoncelo', icon: '/icons/violoncello.svg' },
  { name: 'Piano', icon: '/icons/piano_2.svg' },
  { name: 'Teclado', icon: '/icons/electric-keyboard.svg' },
  { name: 'Voz', icon: '/icons/microphone-with-wire.svg' },
  { name: 'Segunda voz', icon: '/icons/microphone.svg' },
  { name: 'Trompete', icon: '/icons/trumpet.svg' }
])
