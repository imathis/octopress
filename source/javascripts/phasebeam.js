window.onload = function() {
  
  //Create canvas and initialize it's context
  var canvas = document.getElementById("canvas");
  var ctx = canvas.getContext("2d");
  
  //Set the dimensions of canvas equal to the window's dimensions
  var W = window.innerWidth, H = window.innerHeight;
  canvas.width = W;
  canvas.height = H;
  
  //Create an array of circles
  var circles = []; 
  for(var i = 0; i < 20; i++ ){
    circles.push(new create_circle());
  }
  
  //Function to create circles with different positions and velocities
  function create_circle() {
    //Random Position
    this.x = Math.random()*W;
    this.y = Math.random()*H;
    
    //Random Velocities
    this.vx = 0.1+Math.random()*1;
    this.vy = -this.vx;
    
    //Random Radius
    this.r = 10 + Math.random()*50;
  }
  
  //Function to draw the background
  function draw() {
    //Create the gradient
    var grad = ctx.createLinearGradient(0, 0, W, H);
    grad.addColorStop(0, 'rgb(19, 105, 168)');
    grad.addColorStop(1, 'rgb(0, 0, 0)');
    
    //Fill the canvas with the gradient
    ctx.globalCompositeOperation = "source-over";
    ctx.fillStyle = grad;
    ctx.fillRect(0,0,W,H);

    //Fill the canvas with the circles
    for(var j = 0; j < circles.length; j++) {
      var c = circles[j];
      
      //Draw the circle and it with the blur grad
      ctx.beginPath();
      ctx.globalCompositeOperation = "lighter";   
      ctx.fillStyle = grad;
      ctx.arc(c.x, c.y, c.r, Math.PI*2, false);
      ctx.fill();
      
      //Lets use the velocity now
      c.x += c.vx;
      c.y += c.vy;
      
      //To prevent the circles from moving out of the canvas
      if(c.x < -50) c.x = W+50;
      if(c.y < -50) c.y = H+50;
      if(c.x > W+50) c.x = -50;
      if(c.y > H+50) c.y = -50;
    }
  }
  
  setInterval(draw, 25);

}