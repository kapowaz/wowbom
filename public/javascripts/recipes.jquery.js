// recipes, materials and quantities
jQuery(document).ready(function() {
	recipes = [
		{
			id: 47591,
			name: 'Breastplate of the White Knight',
			reagents: [
				{
					id: 37663,
					quantity: 12
				},
				{
					id: 35625,
					quantity: 8
				},
				{
					id: 36925,
					quantity: 2
				},
				{
					id: 47556,
					quantity: 8
				}
			]
		},
		{
			id: 45560,
			name: 'Spiked Deathdealers',
			reagents: [
				{
					id: 37663,
					quantity: 10
				},
				{
					id: 36860,
					quantity: 12
				},
				{
					id: 45087,
					quantity: 6
				}
			]
		},
		{
			id: 45551,
			name: 'Indestructible Plate Girdle',
			reagents: [
				{
					id: 37663,
					quantity: 12
				},
				{
					id: 36913,
					quantity: 30
				},
				{
					id: 45087,
					quantity: 6
				}
			]
		},
		{
			id: 47570,
			name: 'Saronite Swordbreakers',
			reagents: [
				{
					id: 37663,
					quantity: 8
				},
				{
					id: 36913,
					quantity: 20
				},
				{
					id: 47556,
					quantity: 4
				}
			]
		},
		{
			id: 45552,
			name: 'Plate Girdle of Righteousness',
			reagents: [
				{
					id: 37663,
					quantity: 10
				},
				{
					id: 36860,
					quantity: 5
				},
				{
					id: 36913,
					quantity: 20
				},
				{
					id: 45087,
					quantity: 6
				}
			]
		},
		{
			id: 47574,
			name: 'Sunforged Bracers',
			reagents: [
				{
					id: 37663,
					quantity: 8
				},
				{
					id: 35625,
					quantity: 12
				},
				{
					id: 47556,
					quantity: 4
				}
			]
		},
		{
			id: 47593,
			name: 'Sunforged Breastplate',
			reagents: [
				{
					id: 37663,
					quantity: 10
				},
				{
					id: 35625,
					quantity: 20
				},
				{
					id: 47556,
					quantity: 8
				}
			]
		},
		{
			id: 45561,
			name: 'Treads of Destiny',
			reagents: [
				{
					id: 37663,
					quantity: 10
				},
				{
					id: 35622,
					quantity: 12
				},
				{
					id: 36913,
					quantity: 20
				},
				{
					id: 45087,
					quantity: 6
				}
			]
		},
		{
			id: 27984,
			name: 'Enchant Weapon - Mongoose',
			reagents: [
				{
					id: 22450,
					quantity: 6
				},
				{
					id: 22449,
					quantity: 10
				},
				{
					id: 22446,
					quantity: 8
				},
				{
					id: 22445,
					quantity: 40
				},
				{
					id: 39350,
					quantity: 1
				}
			]
		},
		{
			id: 47589,
			name: 'Titanium Razorplate',
			reagents: [
				{
					id: 37663,
					quantity: 10
				},
				{
					id: 36913,
					quantity: 28
				},
				{
					id: 37700,
					quantity: 8
				},
				{
					id: 47556,
					quantity: 8
				}
			]
		},
		{
			id: 47572,
			name: 'Titanium Spikeguards',
			reagents: [
				{
					id: 37663,
					quantity: 8
				},
				{
					id: 36913,
					quantity: 12
				},
				{
					id: 36860,
					quantity: 1
				},
				{
					id: 47556,
					quantity: 4
				}
			]
		},
		{
			id: 37663,
			name: 'Titansteel Bar',
			quality: 'uncommon',
			reagents: [
				{
					id: 41163,
					quantity: 3
				},
				{
					id: 36860,
					quantity: 1
				},
				{
					id: 35624,
					quantity: 1
				},
				{
					id: 35627,
					quantity: 1
				}
			]
		},
		{
			id: 46377,
			name: 'Flask of Endless Rage',
			quantity: 2,
			quality: 'common',
			reagents: [
				{
					id: 36905,
					quantity: 7
				},
				{
					id: 36901,
					quantity: 3
				},
				{
					id: 36908,
					quantity: 1
				},
				{
					id: 40411,
					quantity: 1
				}
			]
		},
		{
			id: 46379,
			name: 'Flask of Stoneblood',
			quantity: 2,
			quality: 'common',
			reagents: [
				{
					id: 36905,
					quantity: 7
				},
				{
					id: 37704,
					quantity: 3
				},
				{
					id: 36908,
					quantity: 1
				},
				{
					id: 40411,
					quantity: 1
				}
			]
		},
	  {
	    id: 62243,
	    name: 'Notched Jawbone',
	    quantity: 1,
	    quality: 'rare',
	    reagents: [
	      {
	        id: 61981,
	        quantity: 12
	      },
	      {
	        id: 52329,
	        quantity: 36
	      },
	      {
	        id: 52327,
	        quantity: 12
	      },
	      {
	        id: 67348,
	        quantity: 1
	      }
	    ]
	  }
	];
});
