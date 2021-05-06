class myListener implements Receiver {
  void send(MidiMessage message, long timeStamp) {

    // System.out.println(message.getStatus());
    if (message instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) message;
      int channel = sm.getChannel();
      int command = sm.getCommand();
      if(channel != 0)return;

      if (command == ShortMessage.NOTE_ON) {
        // String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
        // int note = sm.getData1() % 12;
        // String name = NOTE_NAMES[note];


        int rawKey = sm.getData1();

        Boolean State = true;

        if (sm.getData2() == 0) {
          State = false;
          myBus.sendNoteOff(channel, rawKey, 100);
          for (Note note : notes) {
            if (note.note == rawKey)note.pressing = false;
          }
        } else
        {
          State = true;
          myBus.sendNoteOn(channel, rawKey, 100);
          Note note = new Note(rawKey, channel);
          note.pressing = true;
          notes.add(note);
        }
      } else if (command == ShortMessage.NOTE_OFF) {
        int rawKey = sm.getData1();
        myBus.sendNoteOff(channel, rawKey, 100);
        for (Note note : notes) {
          if (note.note == rawKey)note.pressing = false;
        }
      }
    }
  }

  public void close() {
    System.out.println("O");
  }
}
