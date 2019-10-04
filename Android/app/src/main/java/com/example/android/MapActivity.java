package com.example.android;

import android.graphics.BitmapFactory;
import android.graphics.PointF;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Window;
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
import com.mapbox.mapboxsdk.style.layers.PropertyFactory;
import com.mapbox.mapboxsdk.style.layers.SymbolLayer;
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconAllowOverlap;
import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconOffset;
import static com.mapbox.mapboxsdk.style.layers.PropertyFactory.iconSize;

public class MapActivity extends AppCompatActivity {
    private MapView mapView;
    private PermissionsManager permissionsManager;
    private static final String MARKER_SOURCE_ID = "MARKER_SOURCE_ID";
    private static final String MARKER_ICON_ID = "MARKER_ICON_ID";
    private static final String MARKER_LAYER_ID = "MARKER_LAYER_ID";
    private MapboxMap.OnMapClickListener feature_checker;
    private MapboxMap.OnMapLongClickListener add_marker;
    private List<Feature> features;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Mapbox.getInstance(this, getString(R.string.mapbox_access_token));
        setContentView(R.layout.activity_map);
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
                int i = 0;
                for(Feature feat : features)
                {
                    feat.addStringProperty("title", "Hell" + (++i));
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
                        , new Style.OnStyleLoaded() {
                    @Override
                    public void onStyleLoaded(@NonNull Style style) {

                        // Map is set up and the style has loaded. Now you can add additional data or make other map adjustments.


                    }
                });
                feature_checker = new MapboxMap.OnMapClickListener() {
                    @Override
                    public boolean onMapClick(@NonNull LatLng point) {
                        PointF screenPoint = mapboxMap.getProjection().toScreenLocation(point);
                        List<Feature> features = mapboxMap.queryRenderedFeatures(screenPoint, MARKER_LAYER_ID);
                        if (!features.isEmpty()) {
                            Feature selectedFeature = features.get(0);
                            String title = selectedFeature.getStringProperty("title");
                            Toast.makeText(getBaseContext(), "You selected " + title, Toast.LENGTH_SHORT).show();
                        }
                        return true;
                    }
                };
                mapboxMap.addOnMapClickListener(feature_checker);
                add_marker = new MapboxMap.OnMapLongClickListener() {
                    @Override
                    public boolean onMapLongClick(@NonNull LatLng point) {
                        features.add(Feature.fromGeometry(
                                Point.fromLngLat(point.getLongitude(), point.getLatitude())));
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
                                , new Style.OnStyleLoaded() {
                                    @Override
                                    public void onStyleLoaded(@NonNull Style style) {

                                        // Map is set up and the style has loaded. Now you can add additional data or make other map adjustments.


                                    }
                                });
                        return false;
                    }
                };
                mapboxMap.addOnMapLongClickListener(add_marker);
            }
        });
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
