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