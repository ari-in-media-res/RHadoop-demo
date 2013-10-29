import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class StubReducer extends Reducer<Text, IntWritable, Text, DoubleWritable> {

  @Override
  public void reduce(Text key, Iterable<IntWritable> values, Context context)
      throws IOException, InterruptedException {

	  int sum = 0;
	  int numberOfValues = 0;
	  double avgValue = 0;

		// Go through all values to sum up card values for a card suit
		for (IntWritable value : values) {
			sum += value.get();
			numberOfValues += 1;
		}

		if(numberOfValues != 0){
			avgValue = sum / numberOfValues;
		}
		
		
		context.write(key, new DoubleWritable(avgValue));
	}

  }
