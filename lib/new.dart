floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/attendance.csv';
      createCSV(presentList, absentList, filePath);
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Present List: ${presentList.toString()}'),
                Text('Absent List: ${absentList.toString()}'),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final file = File(filePath);
                    if (await file.exists()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('File downloading...'),
                        ),
                      );
                      try {
                        // Get the file bytes
                        List<int> bytes = await file.readAsBytes();

                        // Save the file with the user's preferred file name and extension
                        await FilePicker.platform.saveFile(
                          fileName: 'attendance.csv',
                          bytes: bytes,
                          mimeType: 'text/csv',
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('File downloaded successfully'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error downloading file'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('File does not exist'),
                        ),
                      );
                    }
                  },
                  child: Text('Download Excel Sheet'),
                ),
              ],
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not access external storage'),
        ),
      );
    }
  },
  child: Icon(Icons.print),
)