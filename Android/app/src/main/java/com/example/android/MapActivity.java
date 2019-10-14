package com.example.android;

import android.arch.core.util.Function;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.PointF;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.mapbox.android.core.permissions.PermissionsManager;
import com.mapbox.geojson.Feature;
import com.mapbox.geojson.FeatureCollection;
import com.mapbox.geojson.Point;
import com.mapbox.mapboxsdk.Mapbox;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.annotations.MarkerOptions;
import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;
import com.mapbox.mapboxsdk.maps.Style;
import com.mapbox.mapboxsdk.plugins.annotation.Symbol;
import com.mapbox.mapboxsdk.plugins.annotation.SymbolManager;
import com.mapbox.mapboxsdk.style.expressions.Expression;
import com.mapbox.mapboxsdk.style.layers.Property;
import com.mapbox.mapboxsdk.style.layers.PropertyFactory;
import com.mapbox.mapboxsdk.style.layers.SymbolLayer;
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.zip.Inflater;

import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconAllowOverlap;
import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconAnchor;
import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconImage;
import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconOffset;
import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconSize;

public class MapActivity extends AppCompatActivity {
    private MapView mapView;
    private PermissionsManager permissionsManager;
    private static final String MARKER_SOURCE_ID = "MARKER_SOURCE_ID";
    private static final String MARKER_ICON_ID = "MARKER_ICON_ID";
    private static final String MARKER_LAYER_ID = "MARKER_LAYER_ID";
    private static final String POPUP_LAYER_ID = "POPUP_LAYER_ID";
    private MapboxMap.OnMapClickListener feature_checker;
    private MapboxMap.OnMapLongClickListener add_marker;
    private List<Feature> features;
    HashMap<String, Bitmap> imgMap = new HashMap<>();
    HashMap<String, View> viewMap = new HashMap<>();
    private int feature_ticker;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Mapbox.getInstance(this, getString(R.string.mapbox_access_token));
        setContentView(R.layout.activity_map);
        final EditText edit = findViewById(R.id.edit_text);
        edit.setVisibility(View.INVISIBLE);
        Button submit = (Button)findViewById(R.id.submit_description);
        submit.setVisibility(View.INVISIBLE);
        mapView = findViewById(R.id.mapView);
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(@NonNull final MapboxMap mapboxMap) {
                features = new ArrayList<>();
                features.add(Feature.fromGeometry(
                        Point.fromLngLat(40.73581, -33.213144)));
                features.add(Feature.fromGeometry(
                        Point.fromLngLat(-73.99155, 40.73581)));
                features.add(Feature.fromGeometry(
                        Point.fromLngLat(-56.990533, -30.583266)));

                for(Feature feat : features)
                {
                    feat.addStringProperty("title", "marker-" + (++feature_ticker));
                    feat.addBooleanProperty("selected", false);
                    feat.addStringProperty("description", "marker-" + (feature_ticker));

                    Bitmap bitmap = fromLayoutToBM(feat);

                    imgMap.put("marker-" + feature_ticker, bitmap);
                }
                mapboxMap.setStyle(new Style.Builder().fromUri("mapbox://styles/mapbox/cjf4m44iw0uza2spb3q0a7s41")

                        // Add the SymbolLayer icon image to the map style
                        .withImage(MARKER_ICON_ID, BitmapFactory.decodeResource(
                                MapActivity.this.getResources(), R.drawable.red_marker))

                        // Adding a GeoJson source for the SymbolLayer icons.
                        .withSource(new GeoJsonSource(MARKER_SOURCE_ID,
                                FeatureCollection.fromFeatures(features)))

                        // Adding the actual SymbolLayer to the map style. An offset is added that the bottom of the red
                        // marker icon gets fixed to the coordinate, rather than the middle of the icon being fixed to
                        // the coordinate point. This is offset is not always needed and is dependent on the image
                        // that you use for the SymbolLayer icon.
                        .withLayer(new SymbolLayer(MARKER_LAYER_ID, MARKER_SOURCE_ID)
                                .withProperties(PropertyFactory.iconImage(MARKER_ICON_ID),
                                        iconAllowOverlap(true),
                                        iconOffset(new Float[] {0f, -9f}),
                                        PropertyFactory.iconSize(.1f))

                        )
                        .withLayer(new SymbolLayer(POPUP_LAYER_ID, MARKER_SOURCE_ID)
                            .withProperties(PropertyFactory.iconImage("{title}"),
                                    iconAnchor(Property.ICON_ANCHOR_BOTTOM_LEFT),
                                    iconOffset(new Float[] {-20.0f, -9.0f}))
                            .withFilter(Expression.eq(Expression.get("selected"), true)))
                        , new Style.OnStyleLoaded() {
                    @Override
                    public void onStyleLoaded(@NonNull Style style) {

                        // Map is set up and the style has loaded. Now you can add additional data or make other map adjustments.
                        style.addImages(imgMap);
                        GeoJsonSource src = (GeoJsonSource)style.getSource(MARKER_SOURCE_ID);
                        src.setGeoJson(FeatureCollection.fromFeatures(features));
                    }
                });
                feature_checker = new MapboxMap.OnMapClickListener() {
                    @Override
                    public boolean onMapClick(@NonNull LatLng point) {
                        PointF screenPoint = mapboxMap.getProjection().toScreenLocation(point);
                        List<Feature> check_features = mapboxMap.queryRenderedFeatures(screenPoint, MARKER_LAYER_ID);
                        for(Feature ft : features)
                        {
                            ft.addBooleanProperty("selected", false);
                        }
                        if (!check_features.isEmpty()) {
                            Feature selectedFeature = check_features.get(0);
                            Feature associated = null;
                            for(Feature ft : features)
                            {
                                if (ft.getStringProperty("title").equals(selectedFeature.getStringProperty("title")))
                                {
                                    ft.addBooleanProperty("selected", true);
                                }
                                else{
                                    ft.addBooleanProperty("selected", false);
                                }
                            }
                            selectedFeature.addBooleanProperty("selected", true);
                            String title = selectedFeature.getStringProperty("title");
                            GeoJsonSource src = (GeoJsonSource)mapboxMap.getStyle().getSource(MARKER_SOURCE_ID);
                            src.setGeoJson(FeatureCollection.fromFeatures(features));
                            Toast.makeText(getBaseContext(), "You selected " + title, Toast.LENGTH_SHORT).show();
                        }
                        return true;
                    }
                };
                mapboxMap.addOnMapClickListener(feature_checker);
                add_marker = new MapboxMap.OnMapLongClickListener() {
                    @Override
                    public boolean onMapLongClick(@NonNull LatLng point) {
                        Feature feat = Feature.fromGeometry(
                                Point.fromLngLat(point.getLongitude(), point.getLatitude()));
                        feat.addBooleanProperty("selected", true);
                        feat.addStringProperty("title", "marker-" + (++feature_ticker));
                        EditText user_input = (EditText)findViewById(R.id.edit_text);
                        user_input.setVisibility(View.VISIBLE);
                        Button submit = (Button)findViewById(R.id.submit_description);
                        submit.setVisibility(View.VISIBLE);
                        feat.addStringProperty("description", "Add Description Above");
                        for(Feature ft : features) {
                            ft.addBooleanProperty("selected", false);
                        }
                        features.add(feat);
                        mapboxMap.getStyle().addImage("marker-" + feature_ticker, fromLayoutToBM(feat));
                        GeoJsonSource src = (GeoJsonSource)mapboxMap.getStyle().getSource(MARKER_SOURCE_ID);
                        src.setGeoJson(FeatureCollection.fromFeatures(features));
                        return false;
                    }
                };
                mapboxMap.addOnMapLongClickListener(add_marker);
                ((Button)findViewById(R.id.submit_description)).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        EditText editText = findViewById(R.id.edit_text);
                        Feature feat = features.get(features.size() - 1);
                        feat.addStringProperty("description", editText.getText().toString());

                        Button submit = (Button)findViewById(R.id.submit_description);
                        submit.setVisibility(View.INVISIBLE);
                        editText.setVisibility(View.INVISIBLE);
                        editText.setText("");
                        mapboxMap.getStyle().addImage("marker-" + feature_ticker, fromLayoutToBM(feat));
                    }
                });
            }
        });
    }

    private Bitmap fromLayoutToBM(Feature feat)
    {
        LinearLayout layout = (LinearLayout) this.getLayoutInflater().inflate(R.layout.popup_description, null, false);
        TextView desc = (TextView)layout.findViewById(R.id.description);
        desc.setText(feat.getStringProperty("description"));
        layout.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
        layout.layout(0, 0, layout.getMeasuredWidth(), layout.getMeasuredHeight());
        layout.setDrawingCacheEnabled(true);
        layout.buildDrawingCache();
        return layout.getDrawingCache();
    }

    @Override
    public void onStart() {
        super.onStart();
        mapView.onStart();
    }

    @Override
    public void onResume() {
        super.onResume();
        mapView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mapView.onPause();
    }

    @Override
    public void onStop() {
        super.onStop();
        mapView.onStop();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mapView.onSaveInstanceState(outState);
    }
}
