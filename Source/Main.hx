package;


import flash.display.Sprite;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		generate();
		
	}

	private function generate()
	{
		var map: Array<Array<String>>;
		
		map = [];
		for (i in 0...9) {
			map[i] = [];
			for (j in 0...9) {
				map[i][j] = newLetter();
			}
		}

		for (i in 0...9) {
			for (j in 0...9) {
				map[i][j] = checkForThrees(map, i, j);
			}
		}
		
		var res = "";

		for (i in 0...9) {
			res += "\n";
			for (j in 0...9) {
				res += " " + map[i][j];
			}
		}

		trace(res);
	}

	private function checkForThrees(map: Array<Array<String>>, i: Int, j: Int): String
	{
		var con: Int;
		var letter = map[i][j];
		do {
			con = 0;
			if (i > 0 && letter == map[i-1][j]) con++;
			if (i <8 && letter == map[i+1][j]) con++;
			if (j > 0 && letter == map[i][j-1]) con++;
			if (j <8 && letter == map[i][j+1]) con++;
			if (con >= 2) {
				do {
					letter = newLetter();
				} while (letter == map[i][j]);
			}
		} while (con >= 2);
		return letter;
	}

	private function newLetter(max = 7): String
	{
		var res = "";
		var rand = Std.random(max);
		switch (rand) {
			case 0: res = 'a';
			case 1: res = 'b';
			case 2: res = 'c';
			case 3: res = 'd';
			case 4: res = 'e';
			case 5: res = 'f';
			case 6: res = 'g';
		}
		return res;
	}
	
	
}