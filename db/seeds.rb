# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create([
  { name: 'Baixista', icon: '/icons/bass-guitar.svg' },
  { name: 'Percussionista', icon: '/icons/conga.svg' },
  { name: 'Baterista', icon: '/icons/drums.svg' },
  { name: 'Guitarrista', icon: '/icons/electric-guitar-1.svg' },
  { name: 'Violonista', icon: '/icons/guitar.svg' },
  { name: 'Violinista', icon: '/icons/violin.svg' },
  { name: 'Violoncelista', icon: '/icons/violoncello.svg' },
  { name: 'Pianista', icon: '/icons/piano_2.svg' },
  { name: 'Tecladista', icon: '/icons/electric-keyboard.svg' },
  { name: 'Vocalista', icon: '/icons/microphone-with-wire.svg' },
  { name: 'Backing vocal', icon: '/icons/microphone.svg' },
  { name: 'Trompetista', icon: '/icons/trumpet.svg' },
  { name: 'Acordeonista', icon: '/icons/accordion.svg' },
  { name: 'Clarinetista', icon: '/icons/inclined-clarinet.svg' },
  { name: 'Flautista', icon: '/icons/flute.svg' },
  { name: 'Harpista', icon: '/icons/harp.svg' },
  { name: 'Saxofonista', icon: '/icons/saxophon.svg' },
  { name: 'Cavaquinista', icon: '/icons/ukelele-2.svg' }
])
