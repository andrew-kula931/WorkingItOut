//List tile for the list of workouts created
/*
  List<Widget> workoutTile (Box box, int index) {
    return box.values.map<Widget>((value) {
      return Padding(
        padding: const EdgeInsets.only(left:20, right:20),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return DocumentWorkout(workoutDb: _workoutBox, index: 0);
              },
            );
          },
          child: ListTile(
          tileColor: Colors.amber,
          title: Text(value.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Workouts: ${value.workouts}'),
              Text('Work Areas: ${value.workAreas?.join(', ') ?? 'No Work Areas'}'),
            ],
          ),
          ),
        ),
        );
    }).toList();
  }
*/





/*
This is a spinning box with a button to control it


late AnimationController _controller;
bool isSpinning = false;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
}

void spinWheel() {
  setState(() {
    isSpinning = !isSpinning;
    if (isSpinning) {
      _controller.forward().then((_) {
        setState(() {
          isSpinning = false;
          _controller.reset();
        });
      });
    }
  });
}


ElevatedButton(
  onPressed: () {
    spinWheel();
  },
  child: const Text('Spin')
),
SizedBox(
  child: RotationTransition(
    turns: _controller,
    child: Container(
      width: 100,
      height: 100,
      color: Colors.blue,
      child: const Center(
        child: Text(
          'Spin',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),
  )
),



ShapeBorder shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8),
  side: BorderSide(color: Colors.black, width: 1));
FlatCardFan(children: [
  PlayingCardView(
    card: PlayingCard(Suit.hearts, CardValue.ace),
    showBack: true,
    elevation: 3.0,
    shape: shape),
  PlayingCardView(
      card: PlayingCard(Suit.hearts, CardValue.ace),
      showBack: true,
      elevation: 3.0,
      shape: shape),
  PlayingCardView(
      card: PlayingCard(Suit.hearts, CardValue.ace),
      showBack: true,
      elevation: 3.0,
      shape: shape),
  PlayingCardView(
      card: PlayingCard(Suit.hearts, CardValue.ace),
      elevation: 3.0,
      shape: shape)
])

*/