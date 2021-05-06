class Note {
  PVector pos = new PVector();
  int note;
  boolean blackKey;
  String code;
  int octave;
  boolean enable = false;
  float len = 0;

  Note(int note_) {
    this.note = note_;
    octave = ((note-21)/12);
    switch(note%12) {
    case 0://C
      pos.x = noteWidth*(7*octave+1);
      code="C"+octave;
      break;
    case 1://C#
      pos.x = noteWidth*(7*octave+1.85)-blackNoteWidth/2;
      blackKey = true;
      code="C#"+octave;
      break;
    case 2://D
      pos.x = noteWidth*(7*octave+2);
      code="D"+octave;
      break;
    case 3://D#
      pos.x = noteWidth*(7*octave+3.15)-blackNoteWidth/2;
      blackKey = true;
      code="D#"+octave;
      break;
    case 4://E
      pos.x = noteWidth*(7*octave+3);
      code="E"+octave;
      break;
    case 5://F
      pos.x = noteWidth*(7*octave+4);
      code="F"+octave;
      break;
    case 6://F#
      pos.x = noteWidth*(7*octave+4.8)-blackNoteWidth/2;
      blackKey = true;
      code="F#"+octave;
      break;
    case 7://G
      pos.x = noteWidth*(7*octave+5);
      code="G"+octave;
      break;
    case 8://G#
      pos.x = noteWidth*(7*octave+6)-blackNoteWidth/2;
      blackKey = true;
      code="G#"+octave;
      break;
    case 9://A
      pos.x = noteWidth*(7*octave-1);
      code="A"+octave;
      break;
    case 10://A#
      pos.x = noteWidth*(7*octave+0.2)-blackNoteWidth/2;
      blackKey = true;
      code="A#"+octave;
      break;
    case 11://B
      pos.x = noteWidth*(7*octave);
      code="B"+octave;
      break;
    }
  }
  
  void update(){
    pos.y += 20;
    if(enable){
      len += 20;
    }
  }
}
